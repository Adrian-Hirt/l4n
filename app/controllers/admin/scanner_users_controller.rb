module Admin
  class ScannerUsersController < AdminController
    add_breadcrumb _('Admin|ScannerUsers'), :admin_scanner_users_path

    def index
      op Operations::Admin::ScannerUser::Index
    end

    def new
      op Operations::Admin::ScannerUser::Create
      add_breadcrumb _('Admin|ScannerUser|New')
    end

    def create
      if run Operations::Admin::ScannerUser::Create
        flash[:success] = _('Admin|ScannerUser|Successfully created')
        redirect_to admin_scanner_users_path
      else
        add_breadcrumb _('Admin|ScannerUser|New')
        flash[:danger] = _('Admin|ScannerUser|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::ScannerUser::Update
      add_breadcrumb model.name
    end

    def update
      if run Operations::Admin::ScannerUser::Update
        flash[:success] = _('Admin|ScannerUser|Successfully updated')
        redirect_to admin_scanner_users_path
      else
        add_breadcrumb model.name
        flash[:danger] = _('Admin|ScannerUser|Update failed')
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::ScannerUser::Destroy
        flash[:success] = _('Admin|ScannerUser|Successfully deleted')
      else
        flash[:danger] = _('Admin|ScannerUser|Cannot be deleted')
      end

      redirect_to admin_scanner_users_path
    end
  end
end
