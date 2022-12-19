module Operations::Ticket
  class RemoveAssignee < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Ticket

    load_model_authorization_action :use

    policy :before_perform do
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

    def lan_party
      @lan_party ||= model.lan_party
    end

    def available_tickets
      Queries::Lan::Ticket::LoadForUserAndLanPartyWithAssigned.call(user: context.user, lan_party: model.lan_party).includes(:seat_category, :seat)
    end

    def ticket_for_lan_party
      @ticket_for_lan_party ||= context.user.ticket_for(lan_party)
    end

    def ticket_upgrades
      @ticket_upgrades ||= ::TicketUpgrade.where(lan_party: lan_party)
                                          .joins(:order)
                                          .where(order: { user: context.user })
                                          .includes(:from_product, :to_product)
    end
  end
end
