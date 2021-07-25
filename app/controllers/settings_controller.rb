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
end
