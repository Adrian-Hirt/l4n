module Operations::Shop::Order
  class PrepareCheckout < RailsOps::Operation
    policy :on_init do
      authorize! :use, :shop
    end

    def perform
      # Delete other orders for user that have status `created`
      run_sub! Operations::Shop::Order::CleanupUntouched

      fail CartEmpty if context.user.cart.cart_items.count.zero?

      # Wrap in a transaction
      ActiveRecord::Base.transaction do
        # Create a new order
        @order = Order.new(user: context.user, status: 'created', cleanup_timestamp: Time.zone.now)

        # For each cart_item, create an order_item and decrease the
        # availability of the product_variant.
        context.user.cart.cart_items.each do |cart_item|
          # Build order_item
          @order.order_items.build(
            product_variant: cart_item.product_variant,
            quantity:        cart_item.quantity,
            price:           cart_item.product_variant.price
          )

          # decrease availability of product_item
          cart_item.product.availability -= cart_item.quantity
          fail MaxQuantityReached if cart_item.product.availability.negative?

          cart_item.product_variant.save!
        end

        @order.save!
      end
    end

    def order
      fail 'Operation not performed yet' unless performed?

      @order
    end

    class CartEmpty < StandardError; end
    class MaxQuantityReached < StandardError; end
  end
end
