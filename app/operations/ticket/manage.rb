module Operations::Ticket
  class Manage < RailsOps::Operation
    schema3 {} # No params allowed for now

    policy :on_init do
      authorize! :use, Ticket
    end

    def available_tickets
      @available_tickets ||= ::Ticket.where(lan_party: lan_party)
                                     .joins(:order)
                                     .where(order: { user: context.user })
                                     .includes(:seat_category, :seat, :assignee)
    end

    def ticket_upgrades
      @ticket_upgrades ||= ::TicketUpgrade.where(lan_party: lan_party)
                                          .joins(:order)
                                          .where(order: { user: context.user })
                                          .includes(:from_product, :to_product)
    end

    def ticket_for_lan_party
      @ticket_for_lan_party ||= context.user.ticket_for(lan_party)
    end

    def lan_party
      ::LanParty.active
    end
  end
end
