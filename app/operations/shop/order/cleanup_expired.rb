module Operations::Shop::Order
  class CleanupExpired < RailsOps::Operation
    without_authorization

    def perform
      # Delete exired orders
      ActiveRecord::Base.transaction do
        # Remove expired created orders
        Order.where(status: Order.statuses[:created]).where('cleanup_timestamp < ?', Time.zone.now - ::Order::TIMEOUT).each do |order|
          Operations::Shop::Order::CleanupSingleOrder.run order: order
        end

        # Remove expired payment pending orders
        Order.where(status: Order.statuses[:payment_pending]).where('cleanup_timestamp < ?', Time.zone.now - ::Order::TIMEOUT_PAYMENT_PENDING).each do |order|
          Operations::Shop::Order::CleanupSingleOrder.run order: order
        end
      end
    end
  end
end
