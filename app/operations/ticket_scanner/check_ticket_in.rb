module Operations::TicketScanner
  class CheckTicketIn < RailsOps::Operation
    schema3 do
      str? :qr_id
    end

    # TODO: add auth
    without_authorization

    policy :before_perform do
      # Check that the qr_id param is given
      fail Operations::Exceptions::OpFailed, _('TicketScanner|Id missing') if osparams.qr_id.blank?
    end

    def perform
      # Check that the ticket is not checked in yet
      fail Operations::Exceptions::OpFailed, _('TicketScanner|Already checked in') if ticket.checked_in?

      # Sanity check: tickets needs to have a seat
      fail Operations::Exceptions::OpFailed, _('TicketScanner|No seat present') if ticket.seat.nil?

      # Otherwise, check the ticket in
      ticket.checked_in!
    end

    delegate :qr_id, to: :osparams

    def ticket
      @ticket ||= begin
        # Decode the urlsafe encoded string
        ciphertext = Base64.urlsafe_decode64(osparams.qr_id)

        # Decrypt the text
        cleartext = Ticket.decrypt_data(ciphertext)

        # Split the text into the ticket_id and the user_id
        ticket_id, user_id = cleartext.split('$')

        # Fail if any of both is blank
        fail Operations::Exceptions::OpFailed, _('TicketScanner|Invalid QR code') if ticket_id.blank? || user_id.blank?

        # Get the ticket
        ticket = Ticket.find_by(id: ticket_id)

        # Fail if ticket is blank
        fail Operations::Exceptions::OpFailed, _('TicketScanner|Invalid QR code') if ticket.blank?

        # Check that the ticket actually has an user assigned
        fail Operations::Exceptions::OpFailed, _('TicketScanner|Ticket has no assignee') if ticket.assignee.nil?

        # Check that the assignee of the ticket is equal to the user_id from the qr code
        fail Operations::Exceptions::OpFailed, _('TicketScanner|Wrong user') unless user_id.to_i == ticket.assignee_id

        # Return the ticket
        ticket
      end
    rescue ArgumentError, ActiveSupport::MessageEncryptor::InvalidMessage
      fail Operations::Exceptions::OpFailed, _('TicketScanner|Invalid QR code')
    end

    def user
      @user ||= ticket.assignee
    end
  end
end
