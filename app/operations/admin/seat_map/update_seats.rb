module Operations::Admin::SeatMap
  class UpdateSeats < RailsOps::Operation
    schema3 do
      str! :lan_party_id
      hsh? :seat_map
      ary? :seats
      ary? :removed_seats
    end

    policy :on_init do
      authorize! :manage, SeatMap
    end

    def perform
      # Delete removed seats
      osparams.removed_seats.each do |removed_seat_id|
        Seat.find(removed_seat_id).destroy!
      end

      # Update or create seats
      osparams.seats.each do |seat_data|
        if seat_data['backendId'].present?
          seat = Seat.find(seat_data['backendId'])
        else
          seat = Seat.new
          seat.seat_map = seat_map
          seat.seat_category = lan_party.seat_categories.first
        end

        seat.data = seat_data.except(:backendId)
        seat.save!
      end
    end

    def lan_party
      @lan_party ||= LanParty.find(osparams.lan_party_id)
    end

    def seat_map
      @seat_map ||= lan_party.seat_map
    end
  end
end
