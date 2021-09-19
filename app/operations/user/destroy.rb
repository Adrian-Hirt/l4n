module Operations::User
  class Destroy < RailsOps::Operation::Model
    schema3 do
      hsh? :auth do
        str! :password
        str? :two_factor_code
      end
    end

    model_authorization_action :destroy_my_user

    model ::User

    def perform
      # Check that the account is destroyable
      fail Operations::User::AccountNotDestroyable unless model.destroyable?

      # Check password
      fail Operations::User::PasswordValidationFailed unless model.authenticate(osparams.dig(:auth, :password))

      # Check two factor code if enabled
      fail Operations::User::TwoFactorValidationFailed if model.two_factor_enabled? && !model.authenticate_otp(osparams.dig(:auth, :two_factor_code), drift: 15)

      run_sub! Operations::SessionHandler::UserLogout, user: model

      model.destroy
    end

    private

    def build_model
      @model = context.user
    end
  end

  class PasswordValidationFailed < StandardError; end
  class TwoFactorValidationFailed < StandardError; end
  class AccountNotDestroyable < StandardError; end
end
