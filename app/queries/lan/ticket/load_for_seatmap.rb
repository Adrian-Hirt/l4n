module Queries::Lan::Ticket
  class LoadForSeatmap < Inquery::Query
    schema3 do
      obj! :user, classes: [User]
      obj! :lan_party, classes: [LanParty]
    end

    def call
      ::Ticket.joins(:order)
              .where(order: { user: osparams.user })
              .where(lan_party: osparams.lan_party)
              .includes(:seat_category)
    end
  end
end
