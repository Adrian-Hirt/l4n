module Operations::Shop::Order
  class CleanupUntouched < RailsOps::Operation
    schema3 {} # No params allowed for now

    without_authorization

    def perform
      # Delete other orders for user that have status `created`
      ActiveRecord::Base.transaction do
        Order.where(user: context.user, status: 'created').find_each do |order|
          Operations::Shop::Order::CleanupSingleOrder.run order: order
        end
      end
    end
  end
end
