module Api
  module V1
    class NewsController < ApiController
      def index
        op Operations::Api::V1::News::Index
        render json: op.result
      end

      def show
        op Operations::Api::V1::News::Load
        render json: op.result
      end
    end
  end
end
