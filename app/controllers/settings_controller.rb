class SettingsController < ApplicationController
  before_action :require_logged_in_user

  def profile
    op Operations::User::UpdateProfile

    return unless request.patch?

    if op.run
      flash.now[:success] = _('User|Profile updated successfully')
    else
      flash.now[:danger] = _('User|Profile could not be updated')
    end
  end

  def avatar
    return unless request.patch?

    current_user.avatar.attach(params[:croppedImage])
    flash[:success] = _('User|Avatar updated successfully')
  end

  def remove_avatar
    current_user.avatar.purge

    flash[:success] = _('User|Avatar removed successfully')
    redirect_to avatar_settings_path
  end

  def activate_two_factor
    if current_user.two_factor_enabled?
      flash[:danger] = _('User|2FA already activated')
      redirect_to two_factor_settings_path
    end

    op Operations::User::Activate2fa

    return unless request.post?

    if op.run
      flash[:success] = _('User|2FA activated successfully')
      redirect_to two_factor_settings_path
    else
      flash.now[:danger] = _('User|2FA code was wrong, please try again')
    end
  end

  def remove_two_factor
    if run Operations::User::Deactivate2fa
      flash[:success] = _('User|2FA removed successfully')
    else
      flash[:danger] = _('User|2FA could not be removed, please try again')
    end
    redirect_to two_factor_settings_path
  end
end
