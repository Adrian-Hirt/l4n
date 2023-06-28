module Operations::TwoFactor
  class Deactivate < RailsOps::Operation
    schema3 do
      hsh? :data do
        str? :otp_code
      end
    end

    without_authorization

    delegate :user, to: :context

    def perform
      # Check that the OTP code is correct
      fail Operations::Exceptions::OpFailed, _('User|Wrong otp code') if user.otp_required_for_login? && !valid_otp_code?

      user.otp_required_for_login = false
      user.otp_secret = nil
      user.otp_backup_codes = nil
      user.save!
    end

    def valid_otp_code?
      user.validate_and_consume_otp!(osparams.data[:otp_code]) || user.invalidate_otp_backup_code!(osparams.data[:otp_code])
    end
  end
end
