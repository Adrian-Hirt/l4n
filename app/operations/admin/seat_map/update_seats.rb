module Operations::Admin::SeatMap
  class UpdateSeats < RailsOps::Operation
    schema3 do
      str! :lan_party_id
      hsh? :seat_map
      ary? :seats do
        list :hash do
          int? :backendId
          int! :seatCategoryId
          num? :x
          num? :y
          num? :height
          num? :width
          num? :scaleX
          num? :scaleY
          num? :rotation
          str? :seatName
        end
      end
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
        seat_id = seat_data.delete(:backendId)

        if seat_id
          seat = Seat.find(seat_id)
        else
          seat = Seat.new
          seat.seat_map = seat_map
        end

        seat_category_id = seat_data.delete(:seatCategoryId)
        seat.seat_category = lan_party.seat_categories.find(seat_category_id)

        seat.name = seat_data.delete(:seatName)

        seat.data = seat_data
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
