module Operations::Admin::Product
  class Update < RailsOps::Operation::Model::Update
    schema do
      req :id
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
