module Operations::Shop::CartItem
  class IncreaseQuantity < RailsOps::Operation::Model::Load
    without_authorization

    policy :on_init do
      authorize! :use, :shop
    end

    model ::CartItem

    def perform
      fail MaxQuantityReached if model.product.inventory <= model.quantity

      model.quantity += 1
      model.save!
    end
  end

  class MaxQuantityReached < StandardError; end
end
