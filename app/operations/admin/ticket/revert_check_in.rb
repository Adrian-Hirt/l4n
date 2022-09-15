module Operations::Admin::Ticket
  class RevertCheckIn < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
    end

    model ::Ticket

    def perform
      # Check that the ticket is checked in
      fail Operations::Exceptions::OpFailed, _('Admin|Ticket|Not checked in') unless model.checked_in?

      model.assigned!
    end
  end
end
