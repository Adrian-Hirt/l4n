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
end
