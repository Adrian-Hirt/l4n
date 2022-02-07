module Operations::Admin::Product
  class Create < RailsOps::Operation::Model::Create
    schema do
      opt :product do
        opt :name
        opt :on_sale
        opt :description
        opt :inventory
        opt :enabled_product_behaviours
        opt :images
        opt :product_variants_attributes
      end
    end

    model ::Product do
      attribute :remove_image
    end
  end
end
