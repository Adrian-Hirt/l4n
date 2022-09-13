module Operations::Ticket
  class TakeSeat < RailsOps::Operation
    policy :on_init do
      authorize! :use, SeatMap
    end

    schema3 do
      int! :id, cast_str: true
      hsh? :ticket do
        int? :selected_seat_id, cast_str: true
      end
    end

    def perform
      # Check that the seat is given
      fail Operations::Exceptions::OpFailed, _('Seat|Not found') if seat.nil?

      # Check that the ticket is given
      fail Operations::Exceptions::OpFailed, _('Ticket|Not found') if ticket.nil?

      # Check that the user can actually use the ticket
      fail Operations::Exceptions::OpFailed, _('Ticket|Not allowed to do that') unless context.view.can?(:use, ticket)

      # Check that the seat is still available
      fail Operations::Exceptions::OpFailed, _('Seat|Already taken') if seat.ticket.present?

      # Check that the categories match
      fail Operations::Exceptions::OpFailed, _('Seat|Mismatched categories') unless seat.seat_category_id == ticket.seat_category_id

      # Check that the ticket does not have a seat already
      fail Operations::Exceptions::OpFailed, _('Ticket|Already used') if ticket.seat.present?

      # If all good, we can assign the seat to the ticket
      seat.ticket = ticket
      seat.save!
    end

    def available_tickets
      Queries::Lan::Ticket::LoadForSeatmap.call(user: context.user, lan_party: ticket.lan_party)
    end

    delegate :lan_party, to: :ticket

    def taken_seat
      seat
    end

    private

    def seat
      @seat ||= ::Seat.find_by(id: osparams.ticket[:selected_seat_id])
    end

    def ticket
      @ticket ||= ::Ticket.find_by(id: osparams.id)
    end
  end
end
