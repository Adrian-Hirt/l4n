module Operations::Shop::Order
  class CleanupUntouched < RailsOps::Operation
    without_authorization

    def perform
      # Delete other orders for user that have status `created`
      ActiveRecord::Base.transaction do
        Order.where(user: context.user, status: 'created').each do |order|
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
  end
end
