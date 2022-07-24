module Operations::Ticket
  class AssignToUser < RailsOps::Operation
    schema3 do
      int! :ticket_id, cast_str: true
      int! :user_id, cast_str: true
    end

    attr_accessor :result

    # No special auth needed
    without_authorization

    def perform
      # Lookup the ticket
      ticket = ::Ticket.find(osparams.ticket_id)

      # Throw exception if the ticket is nil
      fail TicketNotFound if ticket.nil?

      # Check that the current user can assign the ticket
      fail CanCan::AccessDenied unless context.user == ticket.order.user

      # Throw exception if the ticket already has an user assigned
      fail TicketHasUserAssigned if ticket.assignee.present?

      # Find the user to assign the ticket to
      user = ::User.find(osparams.user_id)

      # Throw exception if the user is nil
      fail UserNotFound if user.nil?

      # Throw exception if the user already has an assigned ticket for
      # the current event
      fail UserHasTicketAssigned if ::Ticket.where(lan_party: ticket.lan_party, assignee: user).any?

      # Finally, if all good, assign the ticket
      ticket.assignee = user
      ticket.save!
    end
  end

  class TicketNotFound < StandardError; end
  class UserNotFound < StandardError; end
  class TicketHasUserAssigned < StandardError; end
  class UserHasTicketAssigned < StandardError; end
end
