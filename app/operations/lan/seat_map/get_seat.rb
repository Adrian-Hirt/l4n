module Operations::Lan::SeatMap
  class GetSeat < RailsOps::Operation
    policy :on_init do
      authorize! :use, SeatMap
    end

    schema3 do
      int! :seat_id, cast_str: true
      int! :ticket_id, cast_str: true
    end

    def perform
      seat = Seat.find(osparams.seat_id)
      ticket = Ticket.find(osparams.ticket_id)

      # Check that the user can actually use the ticket
      fail ActiveRecord::RecordInvalid unless context.view.can?(:use, ticket)

      # Check that the seat is still available
      fail ActiveRecord::RecordInvalid if seat.ticket.present?

      # Check that the seatid and ticketid match
      fail ActiveRecord::RecordInvalid unless seat.seat_category_id == ticket.seat_category_id

      # Check that the ticket does not have a seat already
      fail ActiveRecord::RecordInvalid if ticket.seat.present?

      # If all good, we can assign the seat to the ticket
      seat.ticket = ticket
      seat.save!
    end
  end
end
