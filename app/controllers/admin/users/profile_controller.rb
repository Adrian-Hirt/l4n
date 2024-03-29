module Admin
  module Users
    class ProfileController < AdminController
      add_breadcrumb _('Admin|Users'), :admin_users_path

      def edit
        op Operations::Admin::User::UpdateProfile
        add_breadcrumb model.username
        add_breadcrumb _('Admin|User|Profile'), profile_admin_user_path(model)
      end

      def update
        if run Operations::Admin::User::UpdateProfile
          flash[:success] = _('Admin|%{model_name}|Create failed') % { model_name: _('User|Profile') }
          redirect_to profile_admin_user_path
        else
          add_breadcrumb model.username
          add_breadcrumb _('Admin|User|Profile'), profile_admin_user_path(model)
          flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('User|Profile') }
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end
end
