module Operations::Admin::SeatMap
  class LoadSeats < RailsOps::Operation
    schema3 do
      str! :lan_party_id
    end

    policy :on_init do
      authorize! :manage, SeatMap
    end

    def data
      result = {
        seats: []
      }

      seat_map.seats.includes(:seat_category).each do |seat|
        seat_data = {
          backendId:      seat.id,
          seatCategoryId: seat.seat_category_id,
          color:          seat.seat_category.color
        }.merge(seat.data)

        result[:seats] << seat_data
      end

      result
    end

    def lan_party
      @lan_party ||= LanParty.find(osparams.lan_party_id)
    end

    def seat_map
      @seat_map ||= lan_party.seat_map
    end
  end
end
