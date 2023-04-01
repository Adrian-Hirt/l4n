module SekiPayment
  class PaymentController < ApplicationController
    def index
      run Operations::PaymentGateway::GetPaymentInfo
    rescue Operations::PaymentGateway::InvalidOrder => e
      flash[:danger] = e.message
      redirect_to main_app.shop_cart_path
    end

    def submit_order_for_delayed_payment
      if run Operations::PaymentGateway::MarkForDelayedPayment, op_params.merge(gateway_name: 'Seki Payment')
        flash[:success] = _('Order|Successfully submitted for later payment')
        redirect_to main_app.shop_path
      else
        flash[:danger] = _('SekiPayment|There was an error, please try again')
        redirect_to start_payment_path(order_id: params[:order_id])
      end
    rescue Operations::PaymentGateway::InvalidOrder => e
      flash[:danger] = e.message
      redirect_to main_app.shop_cart_path
    end
  end
end
