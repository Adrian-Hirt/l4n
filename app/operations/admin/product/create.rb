module Operations::Admin::Product
  class Create < RailsOps::Operation::Model::Create
    schema do
      opt :lan_party
      opt :product do
        opt :name
        opt :on_sale
        opt :description
        opt :inventory
        opt :enabled_product_behaviours
        opt :images
        opt :product_variants_attributes
        opt :seat_category_id
        opt :product_category_id
        opt :sort
      end
    end

    model ::Product do
      attribute :remove_image
    end

    def grouped_seat_categories
      grouped = SeatCategory.all.group_by(&:lan_party_id)
      grouped.each do |k, v|
        grouped[k] = v.map { |category| { id: category.id, name: category.name } }
      end
    end

    def initial_available_categories
      if model.seat_category
        model.seat_category.lan_party.seat_categories.all
      else
        []
      end
    end
  end
end
