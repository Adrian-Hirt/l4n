module PaypalPayment
  class PaymentController < ApplicationController
    skip_before_action :verify_authenticity_token, only: %i[create_payment execute_payment]

    def index
      run Operations::PaymentGateway::GetPaymentInfo
    rescue Operations::PaymentGateway::InvalidOrder
      flash[:danger] = _('PaypalPaymentGateway|There was an error, please try again')
      redirect_to main_app.shop_cart_path
    end

    def create_payment
      if run PaypalPayment::CreatePayment
        render json: { status: 'ok', paymentID: op.payment_id }
      else
        render json: { status: 'error', message: _('PaypalPaymentGateway|Something went wrong, please try again') }
      end
    end

    def execute_payment
      if run PaypalPayment::ExecutePayment
        flash[:success] = _('Order|Successfully paid for the order')
        render json: { status: 'ok', path: main_app.shop_path }
      else
        render json: { status: 'error', message: _('PaypalPaymentGateway|Something went wrong, please try again') }
      end
    rescue PaypalPayment::ExecutionFailed
      render json: { status: 'error', message: _('PaypalPaymentGateway|Something went wrong, please try again') }
    end
  end
end
