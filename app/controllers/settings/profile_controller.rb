module Settings
  class ProfileController < ApplicationController
    before_action :authenticate_user!

    def edit
      op Operations::User::UpdateProfile
    end

    def update
      op Operations::User::UpdateProfile

      if op.run
        sign_in(model, bypass: true)
        flash[:success] = _('User|Profile updated successfully')
        redirect_to settings_profile_path
      else
        flash.now[:danger] = _('User|Profile could not be updated')
        render :edit, status: :unprocessable_entity
      end
    end
  end
end
