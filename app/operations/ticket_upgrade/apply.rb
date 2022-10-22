module Operations::TicketUpgrade
  class Apply < RailsOps::Operation
    schema3 do
      hsh? :ticket_upgrade do
        int? :upgrade_id, cast_str: true
        int? :ticket_id, cast_str: true
      end
    end

    # We do the auth manually below
    without_authorization

    def perform
      # Check that the ticket and the upgrade are present
      fail Operations::Exceptions::OpFailed, _('TicketUpgrade|Not found') if ticket.nil? || ticket_upgrade.nil?

      # Check that the user is the owner of the ticket
      fail Operations::Exceptions::OpFailed, _('TicketUpgrade|Not allowed to do that') unless ticket.order.user == context.user

      # Check that the user is the owner of the ticket_upgrade
      fail Operations::Exceptions::OpFailed, _('TicketUpgrade|Not allowed to do that') unless ticket_upgrade.order.user == context.user

      # Check that the ticket does not have a seat assigned
      fail Operations::Exceptions::OpFailed, _('TicketUpgrade|Please remove the seat first') if ticket.seat.present?

      # Check that the upgrade has not been used yet
      fail Operations::Exceptions::OpFailed, _('TicketUpgrade|Already used') if ticket_upgrade.used?

      # Check that the "from" category of the upgrade is the category of the ticket
      fail Operations::Exceptions::OpFailed, _('TicketUpgrade|Wrong category') unless ticket_upgrade.from_product.seat_category == ticket.seat_category

      # Finally, if everything worked, we change the category of the ticket,
      # and then increase the availability of the "from" category product by one.
      # Also, we mark the upgrade as used.
      ActiveRecord::Base.transaction do
        ticket.seat_category = ticket_upgrade.to_product.seat_category
        ticket.save!

        ticket_upgrade.from_product.availability += 1
        ticket_upgrade.from_product.save!

        ticket_upgrade.used = true
        ticket_upgrade.save!
      end
    end

    private

    def ticket_upgrade
      @ticket_upgrade ||= ::TicketUpgrade.find_by(id: osparams.ticket_upgrade[:upgrade_id])
    end

    def ticket
      @ticket ||= ::Ticket.find_by(id: osparams.ticket_upgrade[:ticket_id])
    end
  end
end
