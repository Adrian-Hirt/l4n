module Operations::Behaviours
  class TicketUpgrade < Base
    def perform
      # Keep track of how many upgrades we sold
      counter = 0

      from_product = osparams.product.from_product
      to_product = osparams.product.to_product

      osparams.order_item.quantity.times do
        # Increase counter
        counter += 1

        # Create a ticket upgrade
        ::TicketUpgrade.create!({
                                  lan_party:    osparams.product.from_product.seat_category.lan_party,
                                  from_product: osparams.product.from_product,
                                  to_product:   osparams.product.to_product,
                                  order:        osparams.order_item.order
                                })
      end

      # Afterwards, decrease the inventory of the to_product (availability was
      # already decreased earlier). We only increase the inventory of the from_product,
      # the availability is only increased when the upgrade is used.
      to_product.inventory -= counter
      to_product.save!

      from_product.inventory += counter
      from_product.save!
    end

    def self.run_before_checkout(cart_item)
      # Check that the user has at least as many tickets with the same seat_category
      # as the from seat category
      user = cart_item.cart.user
      from_seat_category = cart_item.product_variant.product.from_product.seat_category
      lan_party = from_seat_category.lan_party

      user_tickets = ::Ticket.where(lan_party: lan_party).joins(:order).where(order: { user: user }).where(seat_category: from_seat_category)

      fail Operations::Exceptions::OpFailed, _('TicketUpgrade|You can only buy as many upgrades as the number of upgradeable tickets you own') if user_tickets.count < cart_item.quantity

      # decrease availability of to_product
      to_product = cart_item.product.to_product

      to_product.availability -= cart_item.quantity
      fail Operations::Exceptions::OpFailed, _('CartItem|A ticket upgrade has its max quantity reached!') if to_product.availability.negative?

      to_product.save!
    end

    def self.run_on_cleanup(order_item)
      # Increase availability of the to_product
      to_product = order_item.product.to_product

      to_product.availability += order_item.quantity
      to_product.save!
    end

    def self.run_validations(product)
      # Cannot use this when the ticket is enabled as well
      product.errors.add(:enabled_product_behaviours, _('Product|TicketBehaviour|Invalid combination')) if product.enabled_product_behaviours.include?('ticket')

      # Need to have the from_product and to_product set for this behaviour to make sense
      product.errors.add(:from_product, _('Product|TicketBehaviour|From product needs to be set')) if product.from_product.blank?

      product.errors.add(:to_product, _('Product|TicketBehaviour|To product needs to be set')) if product.to_product.blank?

      # The two products should not be the same
      product.errors.add(:to_product, _('Product|TicketBehaviour|Cannot be the same as the from product')) if product.to_product.present? && product.to_product == product.from_product

      # Return if either isn't set
      return if product.to_product.blank? || product.from_product.blank?

      # Both products need to have a seat category set, and the seat_category needs to be from the same lan_party
      product.errors.add(:to_product, _('Product|TicketBehaviour|Does not have a seat category set!')) if product.from_product.seat_category.nil?

      product.errors.add(:to_product, _('Product|TicketBehaviour|Does not have a seat category set!')) if product.to_product.seat_category.nil?

      product.errors.add(:to_product, _('Product|TicketBehaviour|Does not have the same lan party as the from product')) if product.from_product.seat_category.lan_party != product.to_product.seat_category.lan_party
    end

    def self.render_view(form, product, enabled)
      ApplicationController.render partial: 'behaviours/ticket_upgrade', locals: { f: form, op: self, product: product, enabled: enabled }
    end
  end
end
