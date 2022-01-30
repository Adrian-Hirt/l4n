module Operations::Shop::Order
  class CleanupSingleOrder < RailsOps::Operation
    without_authorization

    delegate :order, to: :osparams

    def perform
      order.order_items.each do |order_item|
        next if order_item.product_variant.nil?

        # increase availability of product_item
        order_item.product_variant.availability += order_item.quantity
        order_item.product_variant.save!
      end

      order.destroy!
    end
  end
end
