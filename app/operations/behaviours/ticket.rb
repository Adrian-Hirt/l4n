module Operations::Behaviours
  class Ticket < Base
    def perform
      osparams.order_item.quantity.times do
        ::Ticket.create!({
                           lan_party:            osparams.product.seat_category.lan_party,
                           seat_category:        osparams.product.seat_category,
                           order:                osparams.order_item.order,
                           product_variant_name: osparams.order_item.product_variant.name
                         })
      end
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
  end
end
