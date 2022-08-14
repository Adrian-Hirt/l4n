module Operations::Admin::PaymentAssist
  class ShowOrder < RailsOps::Operation
    policy :on_init do
      authorize! :use, :payment_assist
    end

    schema3 do
      int! :order_id, cast_str: true
    end

    def order
      @order ||= Order.where(status: Order.statuses[:delayed_payment_pending]).find(osparams.order_id)
    end
  end
end
