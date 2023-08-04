module Operations::Behaviours
  class Ticket < Base
    def perform
      tickets = []

      osparams.order_item.quantity.times do
        ticket = ::Ticket.create!({
                                    lan_party:            osparams.product.seat_category.lan_party,
                                    seat_category:        osparams.product.seat_category,
                                    order:                osparams.order_item.order,
                                    product_variant_name: osparams.order_item.product_variant.name
                                  })

        tickets << ticket
      end

      # Assign the ticket to the user if the user does not have a ticket for that
      # lan party already
      return unless tickets.count == 1

      user = osparams.order_item.order.user
      ticket_to_assign = tickets.first

      return unless user.ticket_for(osparams.product.seat_category.lan_party).nil?

      run_sub! Operations::Ticket::AssignToUser, id: ticket_to_assign.id, assignee: { user_id: user.id }
    end

    def self.run_validations(product)
      # Cannot use this when the ticket_upgrade is enabled as well
      product.errors.add(:enabled_product_behaviours, _('Product|TicketBehaviour|Invalid combination')) if product.enabled_product_behaviours.include?('ticket_upgrade')

      # Need to have the seat_category set for this behaviour to make sense
      product.errors.add(:seat_category, _('Product|TicketBehaviour|Seat category needs to be set')) if product.seat_category.blank?
    end

    def self.render_view(form, product, enabled)
      ApplicationController.render partial: 'behaviours/ticket', locals: { f: form, op: self, product: product, enabled: enabled }
    end

    def self.order_show_hint(order)
      ApplicationController.render partial: 'behaviours/order_show_hints/ticket', locals: { order: order }
    end
  end
end
