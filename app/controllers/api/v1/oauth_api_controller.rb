module Api
  module V1
    class OauthApiController < ActionController::Base # rubocop:disable Rails/ApplicationController
      # All API controllers using the oauth tokens to authorize their
      # endpoints should inherit from this controller. It's important
      # that the endpoints check the oauth token themselfes, as the
      # required scopes usually differ. An example is:
      #
      # before_action -> { doorkeeper_authorize!(:'user:read') }

      wrap_parameters false

      rescue_from ActiveRecord::RecordNotFound do |_exception|
        not_found!
      end

      rescue_from Schemacop::Exceptions::ValidationError do |_exception|
        bad_request!
      end

      private

      # 401 response
      def unauthorized!
        render plain: 'Unauthorized', status: :unauthorized
      end

      # 404 response
      def not_found!
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
    end
  end
end
