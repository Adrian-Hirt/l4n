module Api
  module V1
    class ApiController < ActionController::Base # rubocop:disable Rails/ApplicationController
      before_action :authenticate_with_api_key

      rescue_from ActiveRecord::RecordNotFound do |_exception|
        not_found!
      end

      private

      # This will be changed later, probably to a token-based approach.
      # Right now, we only have public available info anyway in the api,
      # and as such this is "enough security", but it should be changed
      # if the api is extended.
      def authenticate_with_api_key
        # Get key
        api_key = request.headers['X-Api-Key'] || params[:api_key]

        # Return 401 if no api_key was provided
        return unauthorized! if api_key.blank?

        # Find the application with the api_key
        return unauthorized! if ApiApplication.where(api_key: api_key).none?
      end

      # 401 response
      def unauthorized!
        render plain: 'Unauthorized', status: :unauthorized
      end

      # 404 response
      def not_found!
        render plain: 'Not found', status: :not_found
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
    end
  end
end
