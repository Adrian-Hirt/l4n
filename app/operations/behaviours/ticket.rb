module Operations::Behaviours
  class Ticket < Base
    def perform
      osparams.order_item.quantity.times do
        ::Ticket.create!({
                           lan_party:     osparams.product.seat_category.lan_party,
                           seat_category: osparams.product.seat_category,
                           order:         osparams.order_item.order
                         })
      end
    end

    def self.run_validations(product)
      # Need to have the seat_category set for this behaviour to make sense
      return if product.seat_category.present?

      product.errors.add(:seat_category, _('Product|TicketBehaviour|Seat category needs to be set'))
    end

    def self.render_view(form, product, enabled)
      ApplicationController.render partial: 'behaviours/ticket', locals: { f: form, op: self, product: product, enabled: enabled }
    end
  end
end
