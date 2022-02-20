module Grids
  module Admin
    class Tickets < ApplicationGrid
      scope do
        Ticket
      end

      model Ticket

      column :id
      column :order, html: ->(order) { order.user.email }

      filter(:lan_party)
    end
  end
end
