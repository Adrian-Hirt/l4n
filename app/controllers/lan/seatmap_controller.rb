module Lan
  class SeatmapController < LanController
    wrap_parameters false

    def index
      op Operations::Lan::SeatMap::Load
    end

    def seats
      op Operations::Lan::SeatMap::LoadSeats
      render json: op.data
    end
  end
end
