module Admin
  class UsersController < AdminController
    add_breadcrumb _('Admin|Users'), :admin_users_path

    def index
      op Operations::Admin::User::Index
    end

    def new
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('User') }
      op Operations::Admin::User::Create
    end

    def create
      if run Operations::Admin::User::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('User') }
        redirect_to admin_users_path
      else
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('User') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('User') }
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::User::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('User') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('User') }
      end
      redirect_to admin_users_path
    end

    def permissions
      op Operations::Admin::User::ListPermissions
      add_breadcrumb _('Admin|Users|Permissions')
    end
  end
end
