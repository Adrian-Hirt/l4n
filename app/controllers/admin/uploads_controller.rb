module Admin
  class UploadsController < AdminController
    add_breadcrumb _('Admin|Uploads'), :admin_uploads_path

    def index
      op Operations::Admin::Upload::Index
    end

    def new
      op Operations::Admin::Upload::Create
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Upload') }
    end

    def create
      if run Operations::Admin::Upload::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('Upload') }
        redirect_to admin_uploads_path
      else
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Upload') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('Upload') }
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::Upload::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('Upload') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('Upload') }
      end
      redirect_to admin_uploads_path
    end
  end
end
