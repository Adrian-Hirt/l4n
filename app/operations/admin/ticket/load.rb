module Operations::Admin::Ticket
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Ticket

    def qr_code
      data = { qr_id: model.encrypted_qr_id }

      qrcode = RQRCode::QRCode.new(data.to_json, size: 10, level: :h)
      qrcode.as_svg(
        offset:          0,
        color:           '000',
        shape_rendering: 'crispEdges',
        module_size:     4
      )
    end

    def seat_categories
      @seat_categories ||= model.lan_party.seat_categories.order(:name)
    end
  end
end
