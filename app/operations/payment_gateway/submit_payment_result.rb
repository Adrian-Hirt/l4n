module Operations::PaymentGateway
  class SubmitPaymentResult < RailsOps::Operation
    without_authorization

    schema3 do
      str! :order_id
      str! :gateway_name
      str? :payment_id
    end

    def perform
      fail 'No order_id given' if osparams.order_id.blank?

      # Get order
      order = ::Order.find_by(uuid: osparams.order_id)

      # TODO: rollback the payment? or at least signal the user that there
      # was a problem and they should report to the admin?
      fail 'Order not found' if order.nil?

      run_sub Operations::Shop::Order::ProcessPaid, order: order, gateway_name: osparams.gateway_name, payment_id: osparams.payment_id
    end
  end
end
