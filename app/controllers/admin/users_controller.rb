module Admin
  class UsersController < AdminController
    def index
      op Operations::Admin::User::Index
    end

    def show
      op Operations::Admin::User::Load
    end

    def new
      op Operations::Admin::User::Create
    end

    def create
      if run Operations::Admin::User::Create
        flash[:success] = _('User|Successfully created')
        redirect_to admin_users_path
      else
        flash[:danger] = _('User|Create failed')
        render 'new'
      end
    end

    def edit
      op Operations::Admin::User::Update
    end

    def update
      if run Operations::Admin::User::Update
        flash[:success] = _('User|Successfully updated')
        redirect_to admin_users_path
      else
        flash[:danger] = _('User|Update failed')
        render 'edit'
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
