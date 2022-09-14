module Operations::Ticket
  class RemoveAssignee < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Ticket

    attr_accessor :result

    load_model_authorization_action :use

    policy :on_init do
      # TODO: check that the ticket is not checked in

      # TODO: check permissions?
    end

    def perform
      model.assignee = nil
      model.status = Ticket.statuses[:created]
      model.save!
    end

    def lan_party
      @lan_party ||= model.lan_party
    end

    def available_tickets
      Queries::Lan::Ticket::LoadForSeatmap.call(user: context.user, lan_party: model.lan_party)
    end

    def unassigned_seat
      model.seat
    end
  end
end
