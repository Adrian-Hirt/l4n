module Api
  module V1
    class LanPartiesController < ApiController
      # Authenticate with the OAuth token
      before_action -> { doorkeeper_authorize!(:'user:lan:read') }

      # Skip the need for an API key
      skip_before_action :authenticate_with_api_key

      def me
        op Operations::Api::V1::LanParty::Me, op_params.merge(user: current_resource_owner)
        render json: op.result
      rescue Operations::Api::V1::LanParty::LanNotFoundOrNotActive
        data = { message: 'LanParty not found or not active' }
        render json: data, status: :not_found
      rescue Operations::Api::V1::LanParty::UserHasNoTicket
        data = { message: 'User has no ticket assigned for this LanParty' }
        render json: data, status: :unprocessable_entity
      rescue Operations::Api::V1::LanParty::NotCheckedIn
        data = { message: 'User has not checked in at this LanParty' }
        render json: data, status: :unprocessable_entity
      end
    end
  end
end
