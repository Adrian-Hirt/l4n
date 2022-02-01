module Operations::Admin::Product
  class Create < RailsOps::Operation::Model::Create
    schema do
      opt :product do
        opt :name
        opt :on_sale
        opt :description
        opt :inventory
        opt :product_variants_attributes
      end
    end

    model ::Product
  end
end
