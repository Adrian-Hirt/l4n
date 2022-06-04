module Operations::Lan::SeatMap
  class RemoveSeat < RailsOps::Operation
    policy :on_init do
      authorize! :use, SeatMap
    end

    schema3 do
      int! :ticket_id, cast_str: true
    end

    attr_accessor :result

    def perform
      ticket = Ticket.find(osparams.ticket_id)

      # Check that the user can actually use the ticket
      fail ActiveRecord::RecordInvalid unless context.view.can?(:use, ticket)

      # Check that the ticket actually has a seat assigned
      fail ActiveRecord::RecordInvalid if ticket.seat.blank?

      # If all good, we can assign remove the ticket from the
      # seat
      seat = ticket.seat
      seat.ticket = nil
      seat.save!

      @result = {
        seatId: seat.id
      }
    end
  end
end
