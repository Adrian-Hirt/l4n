module Admin
  module Shop
    class OrdersController < AdminController
      add_breadcrumb _('Admin|Orders'), :admin_shop_orders_path

      def index
        op Operations::Admin::Order::Index
      end

      def show
        op Operations::Admin::Order::Load
        add_breadcrumb model.formatted_id, nil
      end

      def cancel_delayed_payment_pending
        if run Operations::Shop::Order::CancelDelayedPaymentPending
          flash[:success] = _('Order|Canceled successfully')
          redirect_to admin_shop_orders_path
        else
          flash[:danger] = _('Order|Cannot be canceled')
          redirect_to admin_shop_order_path(model)
        end
      end
    end
  end
end
