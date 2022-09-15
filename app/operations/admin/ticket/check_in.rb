module Operations::Admin::Ticket
  class CheckIn < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
    end

    model ::Ticket

    def perform
      # Check that the seat is set
      fail Operations::Exceptions::OpFailed, _('Admin|Ticket|Seat not set') if model.seat.nil?

      # Check that the assignee is set
      fail Operations::Exceptions::OpFailed, _('Admin|Ticket|Assignee not set') if model.assignee.nil?

      # Check that the ticket is not checked in already
      fail Operations::Exceptions::OpFailed, _('Admin|Ticket|Already checked in') if model.checked_in?

      model.checked_in!
    end
  end
end
