module Operations::Lan::SeatMap
  class LoadSeats < RailsOps::Operation
    policy :on_init do
      authorize! :read, SeatMap
    end

    def data
      result = {
        seats: []
      }

      seat_map.seats.includes(:seat_category, :ticket).each do |seat|
        seat_data = {
          backendId:      seat.id,
          seatCategoryId: seat.seat_category_id,
          color:          seat.color,
          taken:          seat.ticket.present?,
          userName:       seat.ticket&.assignee&.username,
          userId:         seat.ticket&.assignee_id,
          seatName:       seat.name_or_id
        }.merge(seat.data)

        result[:seats] << seat_data
      end

      result
    end

    def lan_party
      @lan_party ||= LanParty.find_by(active: true)
    end

    def seat_map
      @seat_map ||= lan_party.seat_map
    end
  end
end
