module Operations::Shop::Order
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :read, ::Order
    end

    def orders
      context.user.orders.where(status: Order.statuses[:paid]).order(created_at: :desc)
    end
  end
end
