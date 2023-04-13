module Operations::Admin::PaymentAssist
  class OrderPaid < RailsOps::Operation
    schema3 do
      int! :order_id, cast_str: true
      hsh? :order do
        str? :payment_gateway_payment_id
      end
    end

    policy :on_init do
      authorize! :use, :payment_assist
    end

    def order
      @order ||= Order.where(status: Order.statuses[:delayed_payment_pending]).find(osparams.order_id)
    end

    def perform
      # Check that all products are still available
      fail Operations::Exceptions::OpFailed, _('PaymentAssist|Order has wrong status') unless order.delayed_payment_pending?

      fail Operations::Exceptions::OpFailed, _('PaymentAssist|Order expired') if order.expired?

      # Check that no product_variant has been deleted while loading the payment gateway
      fail Operations::Exceptions::OpFailed, _('PaymentAssist|An product variant has been deleted') if order.order_items.any? { |order_item| order_item.product_variant.nil? }

      # Check that no product is not not on sale anymore
      fail Operations::Exceptions::OpFailed, _('PaymentAssist|An product is not on sale anymore') if order.order_items.any? { |order_item| !order_item.product_variant.product.on_sale? }

      run_sub Operations::Shop::Order::ProcessPaid, order: order, payment_id: osparams.order[:payment_gateway_payment_id].presence
    end
  end
end
