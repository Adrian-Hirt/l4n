module Operations::Session
  class CleanUnusedOtp < RailsOps::Operation
    schema3 ignore_obsolete_properties: true do
      hsh? :user do
        str? :email
        str? :password
        obj? :remember_me
      end
    end

    without_authorization

    def perform
      user = ::User.find_by('lower(email) = ?', osparams.user[:email]&.downcase)

      return if user.nil?

      # Remove any lingering otp fields if the otp has not been activated, as otherwise
      # we get an exception (only if otp is not required)
      return if user.otp_required_for_login?

      user.otp_backup_codes = nil
      user.otp_secret = nil
      user.consumed_timestep = nil
      user.save!
    end
  end
end
