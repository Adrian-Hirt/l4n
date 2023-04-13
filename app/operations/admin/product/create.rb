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
        opt :to_product_id
        opt :from_product_id
        opt :product_category_id
        opt :sort
        opt :show_availability
        opt :archived
      end
    end

    model ::Product do
      attribute :remove_image
    end
  end
end
