module Settings
  class TwoFactorController < ApplicationController
    before_action :authenticate_user!
    before_action :two_factor_not_enabled, only: %i[activate activate_save]

    def index; end

    def activate
      op Operations::TwoFactor::Activate
      op.setup_2fa
    end

    def activate_save
      if run! Operations::TwoFactor::Activate
        flash[:success] = _('TwoFactor|2FA activated successfully')
        redirect_to settings_two_factor_path
      end
    rescue Operations::TwoFactor::InvalidOtpCodeError
      flash.now[:danger] = _('TwoFactor|2FA code was wrong, please try again')
      render :activate, status: :unprocessable_entity
    rescue Operations::TwoFactor::BackupCodesNotConfirmed
      flash.now[:danger] = _('TwoFactor|Please confirm that you saved the backup codes')
      render :activate, status: :unprocessable_entity
    end

    def deactivate
      if run Operations::TwoFactor::Deactivate
        flash[:success] = _('User|2FA removed successfully')
      else
        flash[:danger] = _('User|2FA could not be removed, please try again')
      end
      redirect_to settings_two_factor_path
    end

    private

    def two_factor_not_enabled
      return unless  current_user.two_factor_enabled?

      flash[:danger] = _('User|2FA already activated')
      redirect_to settings_two_factor_path
    end
  end
end
