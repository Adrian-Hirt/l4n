module Lan
  class SeatmapController < LanController
    skip_before_action :require_logged_in_user

    def index
      op Operations::Lan::SeatMap::Load
    end

    def seats
      op Operations::Lan::SeatMap::LoadSeats
      render json: op.data
    end
  end
end
