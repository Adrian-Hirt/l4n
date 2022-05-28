module Operations::Admin::SeatMap
  class LoadForLanParty < RailsOps::Operation::Model
    schema3 do
      str! :lan_party_id
    end

    policy :on_init do
      authorize! :manage, SeatMap
    end

    model ::SeatMap

    def lan_party
      @lan_party ||= LanParty.find(osparams.lan_party_id)
    end

    def model
      @model ||= lan_party.seat_map
    end

    def seat_category_data
      lan_party.seat_categories.map { |category| [category.name, category.id, { data: { color: category.color } }] }
    end
  end
end
