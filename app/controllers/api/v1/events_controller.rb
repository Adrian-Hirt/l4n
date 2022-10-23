module Api
  module V1
    class EventsController < ApiController
      def index
        op Operations::Api::V1::Event::Index
        render json: op.result
      end

      def show
        op Operations::Api::V1::Event::Load
        render json: op.result
      end
    end
  end
end
