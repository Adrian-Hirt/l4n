module Grids
  module Admin
    class Tickets < ApplicationGrid
      scope do
        Ticket.order(:id)
      end

      model Ticket

      column :id
      column :seat_category, html: true do |ticket|
        ticket.seat_category.name
      end

      column :assignee, html: ->(assignee) { assignee&.username }
      column :seat, html: ->(seat) { seat&.id }
      column :status, html: true, &:humanized_status
      column :order, html: ->(order) { link_to order.formatted_id, admin_shop_order_path(order) }

      column :'datagrid-actions', html: true, header: false do |ticket|
        tag.div class: %i[datagrid-actions-wrapper] do
          show_button(ticket, namespace: %i[admin], size: :sm, icon_only: true)
        end
      end

      filter(:lan_party)
    end
  end
end
