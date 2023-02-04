module Operations::Ticket
  class Manage < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model LanParty

    load_model_authorization_action :read_public

    policy :on_init do
      authorize! :use, Ticket
    end

    def available_tickets
      @available_tickets ||= Queries::Lan::Ticket::LoadForUserAndLanParty.call(lan_party: model, user: context.user)
    end

    def ticket_upgrades
      @ticket_upgrades ||= ::TicketUpgrade.where(lan_party: model)
                                          .joins(:order)
                                          .where(order: { user: context.user })
                                          .includes(:from_product, :to_product)
    end

    def ticket_for_lan_party
      @ticket_for_lan_party ||= context.user.ticket_for(model)
    end
  end
end
