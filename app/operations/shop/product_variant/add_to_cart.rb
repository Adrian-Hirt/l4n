module Operations::Shop::ProductVariant
  class AddToCart < RailsOps::Operation::Model::Load
    without_authorization

    model ::ProductVariant

    def perform
      cart = context.view.current_cart
      present_cart_item = cart.cart_items.find_by(product_variant_id: model.id)
      # TODO: check that quantity <= inventory!
      if present_cart_item
        present_cart_item.quantity += 1
        present_cart_item.save!
      else
        cart.cart_items.create!(quantity: 1, product_variant_id: model.id)
      end
    end
  end
end
