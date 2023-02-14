module Operations::TwoFactor
  class Activate < RailsOps::Operation
    schema3 do
      hsh? :two_factor do
        str? :otp_response_code
        int? :backup_codes_saved, cast_str: true
      end
    end

    without_authorization

    attr_accessor :codes

    delegate :user, to: :context

    def perform
      fail Operations::Exceptions::OpFailed, _('TwoFactor|Please confirm that you saved the backup codes') unless params.dig(:two_factor, :backup_codes_saved) == 1
      fail Operations::Exceptions::OpFailed, _('TwoFactor|2FA code was wrong, please try again') unless user.validate_and_consume_otp!(params.dig(:two_factor, :otp_response_code))

      user.otp_required_for_login = true
      user.save!
    end

    def qr_code
      qrcode = RQRCode::QRCode.new(user.otp_provisioning_uri(AppConfig.application_name, issuer: Figaro.env.application_domain!), level: :h)
      qrcode.as_svg(
        offset:          0,
        color:           '000',
        shape_rendering: 'crispEdges',
        module_size:     4
      )
    end

    def setup_2fa
      user.otp_secret = ::User.generate_otp_secret

      # Generate the backup codes
      @codes = user.generate_otp_backup_codes!
      user.save
    end
  end

  class InvalidOtpCodeError < StandardError; end
  class BackupCodesNotConfirmed < StandardError; end
end
