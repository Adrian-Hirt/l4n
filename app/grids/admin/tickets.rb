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
      column :order, html: ->(order) { link_to order.formatted_id, admin_shop_order_path(order) }

      filter(:lan_party)
    end
  end
end
