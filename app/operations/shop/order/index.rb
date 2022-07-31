module Operations::Shop::Order
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :use, :shop
    end

    def completed_orders
      context.user.orders.where(status: Order.statuses[:paid]).order(created_at: :desc)
    end

    def delayed_payment_pending_orders
      context.user.orders.where(status: Order.statuses[:delayed_payment_pending]).order(created_at: :desc)
    end
  end
end
