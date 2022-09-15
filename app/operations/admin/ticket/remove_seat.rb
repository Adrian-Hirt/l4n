module Operations::Admin::Ticket
  class RemoveSeat < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
    end

    model ::Ticket

    def perform
      fail Operations::Exceptions::OpFailed, _('Admin|Ticket|Not found') if model.nil?

      # Check that the ticket actually has a seat assigned
      fail Operations::Exceptions::OpFailed, _('Admin|Ticket|Not assigned to a seat') if model.seat.blank?

      # Check that the ticket is not checked-in
      fail Operations::Exceptions::OpFailed, _('Admin|Ticket|Ticket is already checked in') if model.checked_in?

      # If all good, we can assign remove the ticket from the
      # seat
      seat = model.seat
      seat.ticket = nil
      seat.save!
    end
  end
end
