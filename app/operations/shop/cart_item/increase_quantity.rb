module Operations::Shop::CartItem
  class IncreaseQuantity < RailsOps::Operation::Model::Load
    without_authorization

    model ::CartItem

    def perform
      fail MaxQuantityReached if model.product_variant.inventory <= model.quantity

      model.quantity += 1
      model.save!
    end
  end

  class MaxQuantityReached < StandardError; end
end
