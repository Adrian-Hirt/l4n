module Admin
  class UsersController < AdminController
    add_breadcrumb _('Admin|Users'), :admin_users_path

    def index
      op Operations::Admin::User::Index
    end

    def show
      op Operations::Admin::User::Load
      add_breadcrumb model.username, admin_user_path(model)
    end

    def new
      add_breadcrumb _('Admin|Users|New')
      op Operations::Admin::User::Create
    end

    def create
      if run Operations::Admin::User::Create
        flash[:success] = _('User|Successfully created')
        redirect_to admin_users_path
      else
        add_breadcrumb _('Admin|Users|New')
        flash[:danger] = _('User|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::User::Destroy
        flash[:success] = _('User|Successfully deleted')
      else
        flash[:danger] = _('User|Cannot be deleted')
      end
      redirect_to admin_users_path
    end
  end
end
