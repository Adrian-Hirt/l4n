module Shop
  class OrdersController < ShopController
    def index
      op Operations::Shop::Order::Index
    end

    def show
      op Operations::Shop::Order::Load
    end

    def cancel_delayed_payment_pending
      if run Operations::Shop::Order::CancelDelayedPaymentPending
        flash[:success] = _('Order|Canceled successfully')
        redirect_to shop_orders_path
      else
        flash[:danger] = _('Order|Cannot be canceled')
        redirect_to shop_order_path(model)
      end
    end

    def process_free
      if run Operations::Shop::Order::ProcessFreeOrder
        flash[:success] = _('Order|Successfully completed the order')
      else
        flash[:danger] = _('Order|Cannot process this order')
      end

      respond_to :turbo_stream
    rescue Operations::Exceptions::OpFailed => e
      flash[:danger] = e.message
      respond_to :turbo_stream
    end
  end
end
