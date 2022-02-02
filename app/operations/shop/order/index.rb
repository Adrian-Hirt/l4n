module Operations::Shop::Order
  class Index < RailsOps::Operation
    without_authorization

    policy :on_init do
      authorize! :use, :shop
    end

    def orders
      context.user.orders.where(status: Order.statuses[:paid]).order(created_at: :desc)
    end
  end
end
