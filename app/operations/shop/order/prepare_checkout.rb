module Operations::Shop::Order
  class PrepareCheckout < RailsOps::Operation
    schema3 {} # No params allowed for now

    policy :on_init do
      authorize! :use, :shop
    end

    attr_accessor :total

    def perform
      # Delete other orders for user that have status `created`
      run_sub! Operations::Shop::Order::CleanupUntouched

      fail CartEmpty if context.user.cart.nil? || context.user.cart.cart_items.count.zero?

      # Wrap in a transaction
      ActiveRecord::Base.transaction do
        # Create a new order
        @order = Order.new(user: context.user, status: 'created', cleanup_timestamp: Time.zone.now)

        # For each cart_item, create an order_item and decrease the
        # availability of the product_variant.
        context.user.cart.cart_items.each do |cart_item|
          product = cart_item.product

          # Check that the product still exists
          fail Operations::Exceptions::OpFailed, _('ProductVariant|Product not available anymore') if product.nil?

          # Check that the product is still on sale
          fail Operations::Exceptions::OpFailed, _('ProductVariant|Product not on sale anymore') unless product.on_sale?

          # Build order_item
          @order.order_items.build(
            product_variant: cart_item.product_variant,
            quantity:        cart_item.quantity,
            price:           cart_item.product_variant.price,
            product_name:    "#{cart_item.product_variant.product.name} - #{cart_item.product_variant.name}"
          )

          # decrease availability of product
          product.availability -= cart_item.quantity
          fail Operations::Exceptions::OpFailed, _('ProductVariant|Product not available in the requested quantity anymore') if product.availability.negative?

          # Run any behaviour before_checkout actions we might have
          product.before_checkout_behaviour_actions(cart_item)

          product.save!
        end

        @order.skip_address_validation = true
        @order.save!
        @total = @order.order_items.sum(&:total)
      end
    end

    def order
      fail 'Operation not performed yet' unless performed?

      @order
    end

    def model
      order
    end

    class CartEmpty < StandardError; end
  end
end
