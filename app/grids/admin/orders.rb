module Grids
  module Admin
    class Orders < ApplicationGrid
      scope do
        Order.includes(:user).order(id: :desc)
      end

      model Order

      column :uuid
      column :status, html: true, &:humanized_status
      column :expired, html: true do |order|
        format_boolean(order.expired?)
      end
      column :user, html: ->(user) { user.username }
      column :'datagrid-actions', html: true, header: false do |order|
        tag.div class: %i[datagrid-actions-wrapper] do
          show_button(order, namespace: %i[admin shop], size: :sm, icon_only: true)
        end
      end

      filter(:status, :enum, select: Order.statuses.keys.map { |status| [humanize_enum_for_select(Order, :status, status), status] }, include_blank: _('Form|Select|Show all'))
      filter(:user, :string) do |value, scope, _grid|
        sanitized_value = Order.sanitize_sql_like(value.downcase)
        scope.joins(:user).where('LOWER(users.username) LIKE ?', "%#{sanitized_value}%")
      end
    end
  end
end
