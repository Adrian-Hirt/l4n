module Operations::Admin::Ticket
  class RemoveAssignee < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
    end

    model ::Ticket

    policy :on_init do
      # Check that the ticket is not checked in
      fail Operations::Exceptions::OpFailed, _('Admin|Ticket|Ticket is already checked in') if model.checked_in?

      # Check that the ticket actually has an user assigned
      fail Operations::Exceptions::OpFailed, _('Admin|Ticket|Ticket has no assignee') if model.assignee.nil?
    end

    def perform
      model.assignee = nil
      model.status = Ticket.statuses[:created]
      model.save!
    end
  end
end
