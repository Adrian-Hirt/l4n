module Operations::Shop::Order
  class CleanupUntouched < RailsOps::Operation
    without_authorization

    def perform
      # Delete other orders for user that have status `created`
      ActiveRecord::Base.transaction do
        Order.where(user: context.user, status: 'created').each do |order|
          order.destroy!
        end
      end
    end
  end
end
