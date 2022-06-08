module Grids
  module Admin
    class Tickets < ApplicationGrid
      scope do
        Ticket
      end

      model Ticket

      column :id
      column :order, html: ->(order) { link_to order.formatted_id, admin_shop_order_path(order) }

      filter(:lan_party)
    end
  end
end
