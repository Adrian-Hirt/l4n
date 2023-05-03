module Admin
  class ApiApplicationsController < AdminController
    add_breadcrumb _('Admin|API Applications'), :admin_api_applications_path

    def index
      op Operations::Admin::ApiApplication::Index
    end

    def show
      op Operations::Admin::ApiApplication::Load
      add_breadcrumb model.name
    end

    def new
      op Operations::Admin::ApiApplication::Create
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('API Application') }
    end

    def create
      if run Operations::Admin::ApiApplication::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('API Application') }
        redirect_to edit_admin_api_application_path(model)
      else
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('API Application') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('API Application') }
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::ApiApplication::Update
      add_breadcrumb model.name
    end

    def update
      if run Operations::Admin::ApiApplication::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('API Application') }
        redirect_to admin_api_applications_path
      else
        add_breadcrumb model.name
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('API Application') }
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::ApiApplication::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('API Application') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('API Application') }
      end

      redirect_to admin_api_applications_path
    end
  end
end
