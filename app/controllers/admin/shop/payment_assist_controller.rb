module Admin
  module Shop
    class PaymentAssistController < AdminController
      add_breadcrumb _('Admin|PaymentAssist'), :admin_shop_payment_assist_path

      def index
        op Operations::Admin::PaymentAssist::Index
      end

      def show_order
        op Operations::Admin::PaymentAssist::ShowOrder
        add_breadcrumb op.order.formatted_id, nil
      end

      def order_paid
        if run Operations::Admin::PaymentAssist::OrderPaid
          flash[:success] = _('Admin|PaymentAssist|Order is marked as paid successfully')
          redirect_to admin_shop_payment_assist_path
        else
          add_breadcrumb op.order.formatted_id, nil
          flash[:danger] = _('Admin|PaymentAssist|Order could not be marked as paid')
          redirect_to admin_shop_payment_assist_show_order_path(op.order)
        end
      end
    end
  end
end
