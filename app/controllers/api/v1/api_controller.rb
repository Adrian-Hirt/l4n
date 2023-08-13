module Api
  module V1
    class ApiController < ActionController::Base # rubocop:disable Rails/ApplicationController
      # All API controllers using the oauth tokens to authorize their
      # endpoints should inherit from this controller. It's important
      # that the endpoints check the oauth token themselfes, as the
      # required scopes usually differ. An example is:
      #
      #   before_action -> { doorkeeper_authorize!(:'user:read') }
      #
      # All normal endpoints should use the API key authentication, and as
      # such this is enabled by default. OAuth controllers should skip this
      # and instead use the OAuth token to authenticate
      before_action :authenticate_with_api_key, except: %i[docs]

      # Check that the API is enabled
      before_action :check_feature_flag

      wrap_parameters false

      rescue_from ActiveRecord::RecordNotFound do |_exception|
        not_found!
      end

      rescue_from Schemacop::Exceptions::ValidationError do |_exception|
        bad_request!
      end

      # Docs for the v1 api
      def docs; end

      private

      def authenticate_with_api_key
        # Get key
        api_key = request.headers['X-Api-Key'] || params[:api_key]

        # Return 401 if no api_key was provided
        return unauthorized! if api_key.blank?

        # Find the application with the api_key
        unauthorized! if ApiApplication.where(api_key: api_key).none?
      end

      # 401 response
      def unauthorized!
        render plain: 'Unauthorized', status: :unauthorized
      end

      # 404 response
      def not_found!
        # If api is enabled, we simply return a plain text
        # 404, otherwise we re-raise the excaption, such that
        # the normal 404 page is shown
        fail ActiveRecord::RecordNotFound unless FeatureFlag.enabled?(:api)

        render plain: 'Not found', status: :not_found
      end

      # 400 response
      def bad_request!
        render plain: 'Bad request', status: :bad_request
      end

      # Custom rails_ops context
      def op_context
        @op_context ||= begin
          context = RailsOps::Context.new
          context.url_options = url_options
          context.view = view_context
          context
        end
      end

      # Custom op params, removing the API_KEY
      def op_params
        super.except(:api_key)
      end

      def current_resource_owner
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      def check_feature_flag
        return if FeatureFlag.enabled?(:api_and_oauth)

        fail ActiveRecord::RecordNotFound
      end
    end
  end
end
