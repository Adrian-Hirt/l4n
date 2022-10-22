module Grids
  module Admin
    class TicketUpgrades < ApplicationGrid
      scope do
        TicketUpgrade.order(:id).includes(:from_product, :to_product, :order)
      end

      model TicketUpgrade

      column :id
      column :used, html: ->(used) { format_boolean(used) }
      column :from_product, html: true do |ticket|
        seat_category_badge(ticket.from_product.seat_category)
      end
      column :to_product, html: true do |ticket|
        seat_category_badge(ticket.to_product.seat_category)
      end

      column :order, html: ->(order) { link_to order.formatted_id, admin_shop_order_path(order) }

      filter(:lan_party)
    end
  end
end
