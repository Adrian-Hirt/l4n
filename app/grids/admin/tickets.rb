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
      column :seat, html: ->(seat) { seat&.name_or_id }
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

      def self.available_filters(lan_party)
        lan_party.seat_categories.order(:name).map { |seat_category| [seat_category.name, seat_category.id] }
      end

      filter(:lan_party)
      filter(:seat_category, :enum, select:        proc { |grid| available_filters(grid.lan_party) },
                                    include_blank: _('Form|Select|Show all'))
      filter(:status, :enum, select: Ticket.statuses.keys.map { |status| [humanize_enum_for_select(Ticket, :status, status), status] }, include_blank: _('Form|Select|Show all'))
      filter(:seat_present, :xboolean, include_blank: _('Form|Select|Show all')) do |value, scope, grid|
        if value.is_a?(TrueClass)
          scope.joins(:seat)
        else
          seat_ids = grid.lan_party.seat_map.seats.collect(&:ticket_id)
          scope.where.not(id: seat_ids)
        end
      end
      filter(:order_id, :xboolean, include_blank: _('Form|Select|Show all')) do |value, scope, _grid|
        if value.is_a?(TrueClass)
          scope.where.not(order_id: nil)
        else
          scope.where(order_id: nil)
        end
      end
      filter(:assignee, :string) do |value, scope, _grid|
        sanitized_value = Ticket.sanitize_sql_like(value.downcase)
        scope.joins(:assignee).where('LOWER(users.username) LIKE ?', "%#{sanitized_value}%")
      end
    end
  end
end
