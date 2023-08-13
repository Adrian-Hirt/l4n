module Operations::Ticket
  class LoadMyTicket < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model LanParty

    load_model_authorization_action :read_public

    policy :on_init do
      # Fail if ticket not found
      fail Operations::Exceptions::OpFailed, _('Ticket|No ticket found') if tickets.none?

      # Authorize
      tickets.each do |ticket|
        authorize! :use, ticket
      end
    end

    def tickets
      context.user.tickets_for(model).order(:id)
    end

    def qr_code_for(ticket)
      data = { qr_id: Base64.urlsafe_encode64(ticket.encrypted_qr_id) }

      qrcode = RQRCode::QRCode.new(data.to_json)
      qrcode.as_svg(
        offset:          0,
        color:           '000',
        fill:            'fff',
        shape_rendering: 'crispEdges',
        module_size:     6,
        viewbox:         true
      )
    end
  end
end
