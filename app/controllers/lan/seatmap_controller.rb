module Lan
  class SeatmapController < LanController
    skip_before_action :authenticate_user!

    add_breadcrumb _('Seatmap')

    def index
      op Operations::Lan::SeatMap::Load
    end

    def seats
      op Operations::Lan::SeatMap::LoadSeats
      render json: op.data
    end
  end
end
