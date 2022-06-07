module Operations::Admin::Product
  class Update < RailsOps::Operation::Model::Update
    schema do
      req :id
      opt :lan_party
      opt :product do
        opt :name
        opt :on_sale
        opt :description
        opt :inventory
        opt :enabled_product_behaviours
        opt :images
        opt :remove_images
        opt :product_variants_attributes
        opt :seat_category_id
        opt :product_category_id
      end
    end

    model ::Product do
      attribute :remove_images
    end

    def perform
      # TODO: handle case when availability would fall under zero
      difference = model.inventory - model.inventory_was
      model.availability += difference

      super

      osparams.product[:remove_images]&.each do |id_to_remove|
        model.images.find(id_to_remove).purge
      end
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
