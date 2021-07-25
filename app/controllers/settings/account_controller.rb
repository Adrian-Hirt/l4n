module Settings
  class AccountController < ApplicationController
    layout 'login_register', only: %i[init_destroy_account]
    before_action :require_logged_in_user

    def index; end

    def init_destroy_account; end

    def destroy_account
      run! Operations::User::Destroy

      flash[:success] = _('Settings|Account successfully destroyed')
      redirect_to root_path
    rescue Operations::User::AccountNotDestroyable
      flash[:danger] = _('Settings|Account is not destroyable')
      redirect_to settings_account_destroy_path
    rescue Operations::User::PasswordValidationFailed
      flash[:danger] = _('Settings|Password is incorrect')
      redirect_to settings_account_destroy_path
    rescue Operations::User::TwoFactorValidationFailed
      flash[:danger] = _('Settings|Two factor code is incorrect')
      redirect_to settings_account_destroy_path
    end
  end
end
