module Operations::Shop::Order
  class ProcessPaid < RailsOps::Operation
    delegate :order, to: :osparams

    policy :on_init do
      authorize! :use, :shop
    end

    def perform
      ActiveRecord::Base.transaction do
        # Mark payment as paid
        order.paid!

        order.payment_gateway_name = osparams.gateway_name
        order.payment_gateway_payment_id = osparams.payment_id

        order.save!

        # Decrease inventory of items bought
        order.order_items.each do |order_item|
          order_item.product.inventory -= order_item.quantity
          order_item.product_name = "#{order_item.product.name} - #{order_item.product_variant.name}"
          order_item.save!
          order_item.product.save!

          order_item.product.execute_behaviours(order_item: order_item)
        end

        # Remove the cart to "empty" it
        order.user.cart.destroy!
      end
    end
  end
end
