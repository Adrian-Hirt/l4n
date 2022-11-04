module Queries::Lan
  class CountRelevantTickets < Inquery::Query
    schema3 do
      obj! :lan_party, classes: [LanParty]
    end

    def call
      relevant_categories = osparams.lan_party.seat_categories.where(relevant_for_counter: true)

      ::Ticket.where(seat_category: relevant_categories).count
    end
  end
end
