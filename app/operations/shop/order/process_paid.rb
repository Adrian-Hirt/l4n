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
          order_item.product_variant.inventory -= order_item.quantity
          order_item.product_variant.save!
        end

        # Remove the cart to "empty" it
        order.user.cart.destroy!
      end
    end
  end
end
