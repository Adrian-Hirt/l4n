module DummyPayment
  class PaymentController < ApplicationController
    def index
      run Operations::PaymentGateway::GetPaymentInfo
    end

    def complete_payment
      if run Operations::PaymentGateway::SubmitPaymentResult
        flash[:success] = _('Order|Successfully paid for the order')
        redirect_to main_app.shop_path
      else
        flash[:danger] = _('DummyPayment|There was an error, please try again')
        redirect_to start_payment_path(order_id: params[:order_id])
      end
    end
  end
end
