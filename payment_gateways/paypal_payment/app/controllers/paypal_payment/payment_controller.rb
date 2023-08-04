module PaypalPayment
  class PaymentController < ApplicationController
    skip_before_action :verify_authenticity_token, only: %i[create_payment execute_payment]

    def index
      run Operations::PaymentGateway::GetPaymentInfo
    rescue Operations::PaymentGateway::InvalidOrder => e
      flash[:danger] = e.message
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
        render json: { status: 'ok', path: main_app.shop_order_path(id: params[:order_id]) }
      else
        render json: { status: 'error', message: _('PaypalPaymentGateway|Something went wrong, please try again') }
      end
    rescue PaypalPayment::ExecutionFailed => e
      render json: { status: 'error', message: e.message }
    end
  end
end
