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
  end
end
