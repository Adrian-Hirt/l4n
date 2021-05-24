module Operations::SessionHandler
  class AuthenticateUser < Operations::SessionHandler::SessionOperation
    schema3 do
      hsh! :login do
        str! :email
        str! :password
        str? :remember_me
      end
    end

    without_authorization

    def validation_errors
      super + [Operations::SessionHandler::LoginFailed]
    end

    def perform
      # User exists, is activated and the password is correct
      return if user&.activated? && user&.authenticate(osparams.dig(:login, :password))

      fail Operations::SessionHandler::LoginFailed
    end

    def user
      @user ||= User.find_by(email: osparams.dig(:login, :email))
    end
  end

  class LoginFailed < StandardError; end
end
