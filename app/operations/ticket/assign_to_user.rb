module Operations::Ticket
  class AssignToUser < RailsOps::Operation
    schema3 do
      int! :id, cast_str: true
      hsh? :assignee do
        int? :user_id, cast_str: true
      end
    end

    # No special auth needed
    without_authorization

    def perform
      # Throw exception if the ticket is nil
      fail Operations::Exceptions::OpFailed, _('Ticket|Not found') if ticket.nil?

      # Check that the current user can assign the ticket
      fail CanCan::AccessDenied unless context.user == ticket.order.user

      # Throw exception if the ticket already has an user assigned
      fail Operations::Exceptions::OpFailed, _('Ticket|Already assigned') if ticket.assignee.present?

      # Find the user to assign the ticket to
      user = user_to_assign

      # Throw exception if the user is nil
      fail Operations::Exceptions::OpFailed, _('Ticket|User not found') if user.nil?

      # Throw exception if the user is not confirmed
      fail Operations::Exceptions::OpFailed, _('Ticket|User not confirmed') unless user.confirmed?

      # Throw exception if the user already has an assigned ticket for
      # the current event, except if the lan_party allows to assign multiple
      # tickets per user
      fail Operations::Exceptions::OpFailed, _('Ticket|User already has assigned ticket') if !lan_party.users_may_have_multiple_tickets_assigned? && ::Ticket.where(lan_party: lan_party, assignee: user).any?

      ActiveRecord::Base.transaction do
        # Acquire a lock for the ticket
        ticket.lock!

        # Finally, if all good, assign the ticket
        ticket.assignee = user
        ticket.status = Ticket.statuses[:assigned]
        ticket.save!
      end
    end

    def available_tickets
      Queries::Lan::Ticket::LoadForUserAndLanParty.call(user: context.user, lan_party: ticket.lan_party).includes(:seat_category, :seat)
    end

    def tickets_for_lan_party
      @tickets_for_lan_party ||= context.user.tickets_for(lan_party)
    end

    def lan_party
      @lan_party ||= ticket.lan_party
    end

    def ticket_upgrades
      @ticket_upgrades ||= ::TicketUpgrade.where(lan_party: lan_party)
                                          .joins(:order)
                                          .where(order: { user: context.user })
                                          .includes(:from_product, :to_product)
    end

    private

    def user_to_assign
      ::User.find_by(id: osparams.assignee[:user_id]) if osparams.assignee[:user_id].present?
    end

    def ticket
      @ticket ||= ::Ticket.find_by(id: osparams.id)
    end
  end
end
