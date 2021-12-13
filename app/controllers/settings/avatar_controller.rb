module Settings
  class AvatarController < ApplicationController
    before_action :require_logged_in_user

    def index
      return unless request.patch?

      current_user.avatar.attach(params[:croppedImage])
      flash[:success] = _('User|Avatar updated successfully')
    end

    def destroy
      current_user.avatar.purge

      flash[:success] = _('User|Avatar removed successfully')
      redirect_to settings_avatar_path
    end
  end
end
