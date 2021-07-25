module Operations::TwoFactor
  class Deactivate < RailsOps::Operation
    without_authorization

    delegate :user, to: :context

    def perform
      user.two_factor_enabled = false
      user.otp_secret_key = nil
      user.otp_backup_codes = nil
      user.save
    end
  end
end
