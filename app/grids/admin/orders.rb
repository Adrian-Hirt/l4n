module Grids
  module Admin
    class Orders < ApplicationGrid
      scope do
        Order.includes(:user).order(id: :desc)
      end

      model Order

      column :uuid
      column :status
      column :expired, html: true do |order|
        format_boolean(order.expired?)
      end
      column :user, html: ->(user) { user.username }
      column :'datagrid-actions', html: true, header: false do |order|
        tag.div class: %i[datagrid-actions-wrapper] do
          show_button(order, namespace: %i[admin shop], size: :sm, icon_only: true)
        end
      end
    end
  end
end
