module Settings
  class TwoFactorController < ApplicationController
    before_action :authenticate_user!
    before_action :two_factor_not_enabled, only: %i[activate activate_save]

    add_breadcrumb _('Settings|2FA')

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
    rescue Operations::Exceptions::OpFailed => e
      flash[:danger] = e.message
      respond_to :turbo_stream
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
      return unless  current_user.otp_required_for_login?

      flash[:danger] = _('User|2FA already activated')
      redirect_to settings_two_factor_path
    end
  end
end
