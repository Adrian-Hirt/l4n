module Queries::Lan::Ticket
  class LoadForUserAndLanParty < Inquery::Query
    schema3 do
      obj! :user, classes: [User]
      obj! :lan_party, classes: [LanParty]
    end

    def call
      ::Ticket.where(lan_party: osparams.lan_party)
              .joins(:order)
              .where(order: { user: osparams.user })
              .includes(:seat_category, :seat, :assignee)
    end
  end
end
