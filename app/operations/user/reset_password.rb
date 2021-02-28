module Operations::User
  class ResetPassword < RailsOps::Operation::Model
    schema3 do
      str? :token
      str? :email
      hsh? :user do
        str! :password
        str! :password_confirmation
      end
    end

    model ::User

    policy :on_init do
      # Check if user is present
      fail ResetPasswordRequestInvalid if model.nil?

      # Check that the token is valid
      fail ResetPasswordRequestInvalid unless model.authenticate_password_reset_token(osparams.token)

      # Check that token is not expired
      token_expired = model.password_reset_token_created_at.blank? || (model.password_reset_token_created_at + User::RESET_TOKEN_EXPIRES_AFTER) <= Time.zone.now
      fail ResetPasswordRequestInvalid if token_expired
    rescue BCrypt::Errors::InvalidHash
      fail ResetPasswordRequestInvalid
    end

    without_authorization

    def perform
      model.needs_password_set = true
      model.password = osparams.user[:password]
      model.password_confirmation = osparams.user[:password_confirmation]
      model.password_reset_token = nil
      model.password_reset_token_created_at = nil
      model.save!
    end

    private

    def build_model
      @model = User.find_by(email: osparams.email)
    end
  end

  class ResetPasswordRequestInvalid < StandardError; end
end
