module Queries::Lan
  class CountRelevantProductInventory < Inquery::Query
    schema3 do
      obj! :lan_party, classes: [LanParty]
    end

    def call
      relevant_categories = osparams.lan_party.seat_categories.where(relevant_for_counter: true)

      ::Product.where(seat_category: relevant_categories).sum(&:total_inventory)
    end
  end
end
