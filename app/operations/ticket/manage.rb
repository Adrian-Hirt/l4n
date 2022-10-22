module Operations::Ticket
  class Manage < RailsOps::Operation
    policy :on_init do
      authorize! :use, Ticket
    end

    def tickets
      @tickets ||= ::Ticket.where(lan_party: lan_party)
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

    def lan_party
      ::LanParty.active
    end
  end
end
