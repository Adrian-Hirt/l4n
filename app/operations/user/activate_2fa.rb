module Operations::User
  class Activate2fa < RailsOps::Operation
    schema3 do
      hsh? :two_factor do
        str? :otp_response_code
      end
    end

    without_authorization

    def validation_errors
      super + [InvalidOtpCodeError]
    end

    def perform
      fail InvalidOtpCodeError unless context.user.authenticate_otp(params.dig(:two_factor, :otp_response_code), drift: 15)

      context.user.two_factor_enabled = true
      context.user.save
    end

    def qr_code
      qrcode = RQRCode::QRCode.new(context.user.provisioning_uri(nil, issuer: 'l4n.ch'), size: 10, level: :h)
      qrcode.as_svg(
        offset:          0,
        color:           '000',
        shape_rendering: 'crispEdges',
        module_size:     4
      )
    end
  end

  class InvalidOtpCodeError < StandardError; end
end
