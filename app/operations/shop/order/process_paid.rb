module Operations::Shop::Order
  class ProcessPaid < RailsOps::Operation
    delegate :order, to: :osparams

    without_authorization

    def perform
      ActiveRecord::Base.transaction do
        # Mark payment as paid
        order.paid!

        # Decrease inventory of items bought
        order.order_items.each do |order_item|
          order_item.product.inventory -= order_item.quantity
          order_item.product.save!

          order_item.product.execute_behaviours(order_item: order_item)
        end

        # Remove the cart to "empty" it
        order.user.cart.destroy!
      end
    end
  end
end
