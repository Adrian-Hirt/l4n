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

      def destroy
        if run Operations::Admin::Order::Destroy
          flash[:success] = _('Admin|Order|Destroyed successfully')
          redirect_to admin_shop_orders_path
        else
          flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('Order') }
          redirect_to admin_shop_order_path(model)
        end
      end

      def cleanup_expired
        if run Operations::Admin::Order::CleanupExpired
          flash[:success] = _('Admin|Order|Expired cleaned up successfully')
        else
          flash[:danger] = _('Admin|Order|Expired could not be cleaned up')
        end

        redirect_to admin_shop_orders_path
      end

      def cancel_delayed_payment_pending
        if run Operations::Shop::Order::CancelDelayedPaymentPending
          flash[:success] = _('Admin|Order|Canceled successfully')
          redirect_to admin_shop_orders_path
        else
          flash[:danger] = _('Admin|Order|Cannot be canceled')
          redirect_to admin_shop_order_path(model)
        end
      end
    end
  end
end
