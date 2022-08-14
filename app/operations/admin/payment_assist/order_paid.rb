module Operations::Admin::PaymentAssist
  class OrderPaid < RailsOps::Operation
    policy :on_init do
      authorize! :use, :payment_assist
    end

    schema3 do
      int! :order_id, cast_str: true
      hsh? :order do
        str? :payment_gateway_payment_id
      end
    end

    def order
      @order ||= Order.where(status: Order.statuses[:delayed_payment_pending]).find(osparams.order_id)
    end

    def perform
      run_sub Operations::Shop::Order::ProcessPaid, order: order, payment_id: osparams.order[:payment_gateway_payment_id].presence
    end
  end
end
