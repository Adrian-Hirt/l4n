module Operations::Shop::Order
  class Index < RailsOps::Operation
    schema3 {} # No params allowed for now

    policy :on_init do
      authorize! :use, :shop
    end

    def paid_orders
      context.user.orders
             .where('status = ? OR status = ?', Order.statuses[:processing], Order.statuses[:completed])
             .order(created_at: :desc)
             .includes(:order_items)
    end

    def delayed_payment_pending_orders
      context.user.orders.where(status: Order.statuses[:delayed_payment_pending]).order(created_at: :desc).includes(:order_items)
    end
  end
end
