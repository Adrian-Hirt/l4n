module Operations::Ticket
  class LoadMyTicket < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model LanParty

    load_model_authorization_action :read_public

    policy :on_init do
      # Fail if ticket not found
      fail Operations::Exceptions::OpFailed, _('Ticket|No ticket found') if ticket.nil?

      # Authorize
      authorize! :use, ticket
    end

    def ticket
      context.user.ticket_for(model)
    end

    def qr_code
      data = { qr_id: Base64.urlsafe_encode64(ticket.encrypted_qr_id) }

      qrcode = RQRCode::QRCode.new(data.to_json)
      qrcode.as_svg(
        offset:          0,
        color:           '000',
        shape_rendering: 'crispEdges',
        module_size:     6,
        viewbox:         true
      )
    end
  end
end
