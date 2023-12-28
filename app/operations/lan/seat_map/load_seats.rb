module Operations::Lan::SeatMap
  class LoadSeats < RailsOps::Operation
    schema3 do
      int! :id, cast_str: true
    end

    policy :on_init do
      authorize! :read_public, SeatMap
    end

    def data
      result = {
        seats: []
      }

      seat_map.seats.includes(:seat_category, ticket: :assignee).find_each do |seat|
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
      @lan_party ||= begin
        lan_party = LanParty.find_by(id: osparams.id)

        fail ActiveRecord::RecordNotFound if lan_party.nil? || !lan_party.active? || !lan_party.seatmap_enabled?

        lan_party
      end
    end

    def seat_map
      @seat_map ||= lan_party.seat_map
    end
  end
end
