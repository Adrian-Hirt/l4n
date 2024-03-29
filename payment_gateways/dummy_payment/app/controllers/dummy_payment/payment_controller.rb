module DummyPayment
  class PaymentController < ApplicationController
    def index
      run Operations::PaymentGateway::GetPaymentInfo
    rescue Operations::PaymentGateway::InvalidOrder => e
      flash[:danger] = e.message
      redirect_to main_app.shop_cart_path
    end

    def complete_payment
      if run Operations::PaymentGateway::SubmitPaymentResult, op_params.merge(gateway_name: 'DummyPayment', payment_id: SecureRandom.hex)
        flash[:success] = _('Order|Successfully paid for the order')
        redirect_to main_app.shop_order_path(id: params[:order_id])
      else
        flash[:danger] = _('DummyPayment|There was an error, please try again')
        redirect_to start_payment_path(order_id: params[:order_id])
      end
    end
  end
end
