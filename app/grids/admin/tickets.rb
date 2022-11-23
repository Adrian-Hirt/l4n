module Grids
  module Admin
    class Tickets < ApplicationGrid
      scope do
        Ticket.order(:id).includes(:seat, :seat_category, :assignee, :order)
      end

      model Ticket

      column :seat_category, html: true do |ticket|
        ticket_seat_category_badge(ticket)
      end
      column :product_variant_name

      column :assignee, html: ->(assignee) { assignee&.username }
      column :seat, html: ->(seat) { seat&.id }
      column :status, html: true, &:humanized_status
      column :order, html: true do |ticket|
        if ticket.order.present?
          link_to ticket.order.formatted_id, admin_shop_order_path(ticket.order)
        else
          _('Admin|Ticket|Generated in admin panel')
        end
      end

      column :'datagrid-actions', html: true, header: false do |ticket|
        tag.div class: %i[datagrid-actions-wrapper] do
          show_button(ticket, namespace: %i[admin], size: :sm, icon_only: true)
        end
      end

      filter(:lan_party)
    end
  end
end
