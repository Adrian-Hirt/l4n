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
      fail InvalidOtpCodeError unless user.validate_and_consume_otp!(params.dig(:two_factor, :otp_response_code))

      user.otp_required_for_login = true
      user.save!
    end

    def qr_code
      qrcode = RQRCode::QRCode.new(user.otp_provisioning_uri('L4N', issuer: 'l4n.ch'), level: :h)
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
      otp_backup_codes
      user.save
    end

    def otp_backup_codes
      @otp_backup_codes ||= user.generate_otp_backup_codes!
    end
  end

  class InvalidOtpCodeError < StandardError; end
  class BackupCodesNotConfirmed < StandardError; end
end
