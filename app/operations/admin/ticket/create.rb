module Operations::Admin::Ticket
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      int! :lan_party_id, cast_str: true
      hsh? :ticket do
        obj? :seat_category_id
      end
    end

    model ::Ticket

    def perform
      model.lan_party = lan_party
      super
    end

    def available_seat_categories
      @available_seat_categories ||= lan_party.seat_categories.order(:name).reject { |seat_category| seat_category.product.present? }
    end

    def lan_party
      @lan_party ||= ::LanParty.find(osparams.lan_party_id)
    end
  end
end
