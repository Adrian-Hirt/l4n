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
        redirect_to admin_users_path
      else
        render 'new'
      end
    end

    def edit
      op Operations::Admin::User::Update
    end

    def update
      if run Operations::Admin::User::Update
        redirect_to admin_users_path
      else
        render 'edit'
      end
    end

    def destroy
      if run Operations::Admin::User::Destroy

      end
      redirect_to admin_users_path
    end
  end
end
