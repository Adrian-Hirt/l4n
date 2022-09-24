module Operations::Ticket
  class AssignToUser < RailsOps::Operation
    schema3 do
      int! :id, cast_str: true
      int? :user_id, cast_str: true
      hsh? :assignee do
        str? :username
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

      # Throw exception if the user is not activated
      fail Operations::Exceptions::OpFailed, _('Ticket|User not activated') unless user.activated?

      # Throw exception if the user already has an assigned ticket for
      # the current event
      fail Operations::Exceptions::OpFailed, _('Ticket|User already has assigned ticket') if ::Ticket.where(lan_party: lan_party, assignee: user).any?

      # Finally, if all good, assign the ticket
      ticket.assignee = user
      ticket.status = Ticket.statuses[:assigned]
      ticket.save!
    end

    def available_tickets
      Queries::Lan::Ticket::LoadForSeatmap.call(user: context.user, lan_party: ticket.lan_party).includes(:seat_category, :seat)
    end

    def ticket_for_lan_party
      @ticket_for_lan_party ||= context.user.ticket_for(lan_party)
    end

    def lan_party
      @lan_party ||= ticket.lan_party
    end

    def assigned_seat
      ticket.seat
    end

    def assigned_user
      @assigned_user ||= user_to_assign
    end

    private

    def user_to_assign
      if osparams.user_id.present?
        ::User.find_by(id: osparams.user_id)
      else
        ::User.find_by('LOWER(username) = ?', osparams.assignee[:username].downcase)
      end
    end

    def ticket
      @ticket ||= ::Ticket.find_by(id: osparams.id)
    end
  end
end
