module Operations::Shop::Order
  class ProcessMarkedForDelayedPayment < RailsOps::Operation
    delegate :order, to: :osparams

    without_authorization

    def perform
      ActiveRecord::Base.transaction do
        # Mark payment as delayed payment pending
        order.delayed_payment_pending!

        order.payment_gateway_name = osparams.gateway_name
        order.payment_gateway_payment_id = osparams.payment_id

        order.save!

        # Remove the cart to "empty" it
        order.user.cart.destroy!
      end
    end
  end
end
