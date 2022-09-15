module Operations::Ticket
  class RemoveSeat < RailsOps::Operation
    policy :on_init do
      authorize! :use, SeatMap
    end

    schema3 do
      int! :id, cast_str: true
    end

    def perform
      fail Operations::Exceptions::OpFailed, _('Ticket|Not found') if ticket.nil?

      # Check that the user can actually use the ticket
      fail Operations::Exceptions::OpFailed, _('Ticket|Not allowed') unless context.view.can?(:use, ticket)

      # Check that the ticket actually has a seat assigned
      fail Operations::Exceptions::OpFailed, _('Ticket|Not assigned to a seat') if ticket.seat.blank?

      # Check that the ticket is not checked-in
      fail Operations::Exceptions::OpFailed, _('Ticket|Ticket is already checked in') if ticket.checked_in?

      # If all good, we can assign remove the ticket from the
      # seat
      seat = ticket.seat
      @removed_seat_id = seat.id
      seat.ticket = nil
      seat.save!
    end

    def ticket
      @ticket ||= ::Ticket.find_by(id: osparams.id)
    end

    def lan_party
      @lan_party ||= ticket.lan_party
    end

    def available_tickets
      Queries::Lan::Ticket::LoadForSeatmap.call(user: context.user, lan_party: ticket.lan_party)
    end

    attr_reader :removed_seat_id
  end
end
