module Operations::SessionHandler
  class AuthenticateTwoFactor < Operations::SessionHandler::SessionOperation
    schema3 do
      hsh! :login do
        str! :two_factor_code
      end
    end
    without_authorization

    def validation_errors
      super + [Operations::SessionHandler::TwoFactorValidationFailed]
    end

    def perform
      return if user.authenticate_otp osparams.dig(:login, :two_factor_code), drift: 15

      fail Operations::SessionHandler::TwoFactorValidationFailed
    end

    def user
      @user ||= User.find(context.session[:tmp_login][:user_id])
    end

    def remember_me
      !!context.session[:tmp_login][:remember_me]
    end
  end

  class TwoFactorValidationFailed < StandardError; end
end
