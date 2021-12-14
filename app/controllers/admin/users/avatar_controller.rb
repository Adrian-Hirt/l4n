module Admin
  module Users
    class AvatarController < AdminController
      add_breadcrumb _('Admin|Users'), :admin_users_path

      def edit
        op Operations::Admin::User::UpdateAvatar
        add_breadcrumb model.username, admin_user_path(model)
        add_breadcrumb _('Admin|Users|Avatar'), avatar_admin_user_path(model)

        return unless request.patch?

        op.run
        flash[:success] = _('Admin|Users|Avatar|Avatar updated successfully')
      end

      def destroy
        run Operations::Admin::User::RemoveAvatar
        flash[:success] = _('Admin|Users|Avatar|Avatar removed successfully')
        redirect_to avatar_admin_user_path(model)
      end
    end
  end
end
