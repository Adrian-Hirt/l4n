module Operations::Admin::Order
  class CleanupExpired < RailsOps::Operation
    policy :on_init do
      authorize! :manage, Order
    end

    def perform
      # Delete exired orders
      ActiveRecord::Base.transaction do
        # Remove expired created orders
        Queries::Order::FetchCreatedExpired.run.each do |order|
          Operations::Shop::Order::CleanupSingleOrder.run order: order
        end

        # Remove expired payment pending orders
        Queries::Order::FetchPaymentPendingExpired.run.each do |order|
          Operations::Shop::Order::CleanupSingleOrder.run order: order
        end

        # Remove expired delayed payment pending orders
        Queries::Order::FetchDelayedPaymentPendingExpired.run.each do |order|
          Operations::Shop::Order::CleanupSingleOrder.run order: order
        end
      end
    end
  end
end
