module Operations::Shop::ProductVariant
  class AddToCart < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    policy :on_init do
      authorize! :use, :shop
    end

    load_model_authorization_action nil

    model ::ProductVariant

    lock_mode :exclusive

    def perform
      cart = context.view.current_cart
      present_cart_item = cart.cart_items.find_by(product_variant_id: model.id)

      if present_cart_item
        fail MaxQuantityReached if model.product.availability <= present_cart_item.quantity

        present_cart_item.quantity += 1
        present_cart_item.save!
      else
        fail MaxQuantityReached if model.product.availability.zero?

        cart.cart_items.create!(quantity: 1, product_variant_id: model.id)
      end
    end
  end

  class MaxQuantityReached < StandardError; end
end
