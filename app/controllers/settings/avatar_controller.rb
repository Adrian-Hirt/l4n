module Settings
  class AvatarController < ApplicationController
    before_action :authenticate_user!

    add_breadcrumb _('Settings|Avatar')

    def index
      return unless request.patch?

      if current_user.avatar.attach(params[:croppedImage])
        flash[:success] = _('User|Avatar updated successfully')
      else
        flash[:danger] = _('User|Avatar could not be uploaded!')
      end
    end

    def destroy
      current_user.avatar.purge

      flash[:success] = _('User|Avatar removed successfully')
      redirect_to settings_avatar_path
    end
  end
end
