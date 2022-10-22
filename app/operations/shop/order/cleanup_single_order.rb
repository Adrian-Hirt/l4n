module Operations::Shop::Order
  class CleanupSingleOrder < RailsOps::Operation
    schema3 do
      obj! :order, classes: [Order], strict: false
    end

    without_authorization

    delegate :order, to: :osparams

    def perform
      fail 'Not possible to cleanup this order' unless order.expired? || order.created? || order.delayed_payment_pending?

      order.order_items.each do |order_item|
        next if order_item.product_variant.nil?

        # increase availability of product_item
        order_item.product.availability += order_item.quantity
        order_item.product.save!

        # Run any behaviour on_cleanup actions we might have
        order_item.product.on_cleanup_behaviour_actions(order_item)
      end

      order.destroy!
    end
  end
end
