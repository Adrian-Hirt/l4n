module Admin
  module Users
    class PermissionsController < AdminController
      add_breadcrumb _('Admin|Users'), :admin_users_path

      def edit
        op Operations::Admin::User::UpdatePermissions
        add_breadcrumb model.username
        add_breadcrumb _('Admin|User|Permissions'), permissions_admin_user_path(model)
      end

      def update
        if run Operations::Admin::User::UpdatePermissions
          flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('User|Permissions') }
          redirect_to permissions_admin_user_path
        else
          add_breadcrumb model.username
          add_breadcrumb _('Admin|User|Permissions'), permissions_admin_user_path(model)
          flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('User|Permissions') }
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end
end
