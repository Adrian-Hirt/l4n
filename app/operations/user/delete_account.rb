module Operations::User
  class DeleteAccount < RailsOps::Operation::Model
    schema3 do
      hsh? :data do
        str? :password
        str? :otp_code
      end
    end

    # Uses context user, so no need to authorize
    without_authorization

    model ::User

    def perform
      # Check that the user is actually deleteable
      fail Operations::Exceptions::OpFailed, _('User|Account|Not deleteable') unless model.deleteable?

      # Check the password
      fail Operations::Exceptions::OpFailed, _('User|Account|Wrong password to delete') unless model.valid_password?(osparams.data[:password])

      # If the user has 2FA enabled, check that the OTP code is correct
      fail Operations::Exceptions::OpFailed, _('User|Account|Wrong OTP code to delete') if model.otp_required_for_login? && !valid_otp_code?

      # Finally, delete the user
      model.destroy!
    end

    private

    def build_model
      @model = context.user
    end

    def valid_otp_code?
      model.validate_and_consume_otp!(osparams.data[:otp_code]) || model.invalidate_otp_backup_code!(osparams.data[:otp_code])
    end
  end
end
