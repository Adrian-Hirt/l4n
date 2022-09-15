module Operations::Admin::Ticket
  class AssignSeat < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :seat do
        int? :seat_id, cast_str: true
      end
    end

    model ::Ticket

    def perform
      # Check that the seat is given
      fail Operations::Exceptions::OpFailed, _('Admin|Seat|Not found') if seat.nil?

      # Check that the ticket is given
      fail Operations::Exceptions::OpFailed, _('Admin|Ticket|Not found') if model.nil?

      # Check that the seat is still available
      fail Operations::Exceptions::OpFailed, _('Admin|Seat|Already taken') if seat.ticket.present?

      # Check that the categories match
      fail Operations::Exceptions::OpFailed, _('Admin|Seat|Mismatched categories') unless seat.seat_category_id == model.seat_category_id

      # Check that the ticket does not have a seat already
      fail Operations::Exceptions::OpFailed, _('Admin|Ticket|Already used') if model.seat.present?

      seat.ticket = model
      seat.save!
    end

    private

    def seat
      @seat ||= ::Seat.find_by(id: osparams.seat[:seat_id])
    end
  end
end
