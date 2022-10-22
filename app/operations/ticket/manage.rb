module Operations::Ticket
  class Manage < RailsOps::Operation
    policy :on_init do
      authorize! :use, Ticket
    end

    def tickets
      @tickets ||= ::Ticket.where(lan_party: lan_party)
                           .joins(:order)
                           .where(order: { user: context.user })
                           .includes(:seat_category)
                           .distinct
    end

    def ticket_upgrades
      @ticket_upgrades ||= ::TicketUpgrade.where(lan_party: lan_party)
                                          .joins(:order)
                                          .where(order: { user: context.user })
    end

    def lan_party
      ::LanParty.active
    end
  end
end
