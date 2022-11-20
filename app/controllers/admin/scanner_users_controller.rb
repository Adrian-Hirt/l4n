module Admin
  class ScannerUsersController < AdminController
    add_breadcrumb _('Admin|ScannerUsers'), :admin_scanner_users_path

    def index
      op Operations::Admin::ScannerUser::Index
    end

    def new
      op Operations::Admin::ScannerUser::Create
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('ScannerUser') }
    end

    def create
      if run Operations::Admin::ScannerUser::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('ScannerUser') }
        redirect_to admin_scanner_users_path
      else
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('ScannerUser') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('ScannerUser') }
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::ScannerUser::Update
      add_breadcrumb model.name
    end

    def update
      if run Operations::Admin::ScannerUser::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('ScannerUser') }
        redirect_to admin_scanner_users_path
      else
        add_breadcrumb model.name
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('ScannerUser') }
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::ScannerUser::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('ScannerUser') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('ScannerUser') }
      end

      redirect_to admin_scanner_users_path
    end
  end
end
