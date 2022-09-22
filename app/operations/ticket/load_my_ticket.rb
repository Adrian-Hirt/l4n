module Operations::Ticket
  class LoadMyTicket < RailsOps::Operation
    policy :on_init do
      # Fail if ticket not found
      fail Operations::Exceptions::OpFailed, _('Ticket|No ticket found') if ticket.nil?

      # Authorize
      authorize! :use, ticket
    end

    def ticket
      context.user.ticket_for(lan_party)
    end

    def qr_code
      data = { qr_id: Base64.urlsafe_encode64(ticket.encrypted_qr_id) }

      qrcode = RQRCode::QRCode.new(data.to_json)
      qrcode.as_svg(
        offset:          0,
        color:           '000',
        shape_rendering: 'crispEdges',
        module_size:     6
      )
    end

    def lan_party
      ::LanParty.active
    end
  end
end
