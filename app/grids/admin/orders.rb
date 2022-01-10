module Grids
  module Admin
    class Orders < ApplicationGrid
      include Datagrid

      scope do
        Order.includes(:order_items)
      end

      model Order

      column :id
      column :user, html: ->(user) { user.username }
      column :order_items, html: ->(order_items) { order_items.count }, header: _('Order|Order items count')
      column :'datagrid-actions', html: true, header: false do |order|
        tag.div class: %i[datagrid-actions-wrapper] do
          show_button(order, namespace: %i[admin], size: :sm, icon_only: true)
        end
      end
    end
  end
end
