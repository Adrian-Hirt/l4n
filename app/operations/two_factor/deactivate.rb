module Operations::TwoFactor
  class Deactivate < RailsOps::Operation
    without_authorization

    delegate :user, to: :context

    def perform
      user.otp_required_for_login = false
      user.otp_secret = nil
      user.otp_backup_codes = nil
      user.save!
    end
  end
end
