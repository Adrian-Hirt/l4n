module Grids
  module Admin
    class PaymentAssistOrders < ApplicationGrid
      scope do
        Order.where(status: Order.statuses[:delayed_payment_pending]).includes(:order_items).order(id: :desc)
      end

      model Order

      column :id
      column :user, html: ->(user) { user.username }
      column :'datagrid-actions', html: true, header: false do |order|
        tag.div class: %i[datagrid-actions-wrapper] do
          show_button(order, namespace: %i[admin shop], size: :sm, icon_only: true, href: admin_shop_payment_assist_show_order_path(order))
        end
      end
    end
  end
end
