module Operations::User
  class RequestPasswordReset < RailsOps::Operation
    schema3 do
      hsh! :password_reset_request do
        str! :email
      end
    end

    without_authorization

    def perform
      user = User.find_by(email: osparams.email)

      return if user.nil?

      reset_token = SecureRandom.urlsafe_base64(64)

      user.password_reset_token = reset_token
      user.password_reset_token_created_at = Time.zone.now
      user.save

      UserMailer.with(user: model, reset_token: reset_token).password_reset_request.deliver_now
    end
  end
end
