module Operations::Admin::Product
  class Update < RailsOps::Operation::Model::Update
    schema do
      req :id
      opt :product do
        opt :name
        opt :on_sale
        opt :description
        opt :inventory
        opt :enabled_product_behaviours
        opt :image
        opt :remove_image
        opt :product_variants_attributes
      end
    end

    model ::Product do
      attribute :remove_image
    end

    def perform
      super

      model.image.purge if ActiveModel::Type::Boolean.new.cast(osparams.product[:remove_image])
    end
  end
end
