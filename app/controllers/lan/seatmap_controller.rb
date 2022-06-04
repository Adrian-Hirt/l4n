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

    # rubocop:disable Naming/AccessorMethodName
    def get_seat
      if run Operations::Lan::SeatMap::GetSeat
        head :ok
      else
        head :bad_request
      end
    end
    # rubocop:enable Naming/AccessorMethodName

    def remove_seat
      if run Operations::Lan::SeatMap::RemoveSeat
        render json: op.result.as_json
      else
        head :bad_request
      end
    end
  end
end
