module Operations::TwoFactor
  class Activate < RailsOps::Operation
    schema3 do
      hsh? :two_factor do
        str? :otp_response_code
        int? :backup_codes_saved, cast_str: true
      end
    end

    without_authorization

    delegate :user, to: :context

    def perform
      fail BackupCodesNotConfirmed unless params.dig(:two_factor, :backup_codes_saved) == 1
      fail InvalidOtpCodeError unless user.authenticate_otp(params.dig(:two_factor, :otp_response_code), drift: 15)

      user.two_factor_enabled = true
      user.save
    end

    def qr_code
      qrcode = RQRCode::QRCode.new(user.provisioning_uri(nil, issuer: 'l4n.ch'), size: 10, level: :h)
      qrcode.as_svg(
        offset:          0,
        color:           '000',
        shape_rendering: 'crispEdges',
        module_size:     4
      )
    end

    def setup_2fa
      user.otp_regenerate_secret
      user.otp_regenerate_backup_codes
      user.save
    end
  end

  class InvalidOtpCodeError < StandardError; end
  class BackupCodesNotConfirmed < StandardError; end
end
