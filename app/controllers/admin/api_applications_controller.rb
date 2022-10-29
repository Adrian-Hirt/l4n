module Admin
  class ApiApplicationsController < AdminController
    add_breadcrumb _('Admin|API Applications'), :admin_api_applications_path

    def index
      op Operations::Admin::ApiApplication::Index
    end

    def new
      op Operations::Admin::ApiApplication::Create
      add_breadcrumb _('Admin|API Application|New')
    end

    def create
      if run Operations::Admin::ApiApplication::Create
        flash[:success] = _('Admin|API Application|Successfully created')
        redirect_to edit_admin_api_application_path(model)
      else
        add_breadcrumb _('Admin|API Application|New')
        flash[:danger] = _('Admin|API Application|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::ApiApplication::Update
      add_breadcrumb model.name
    end

    def update
      if run Operations::Admin::ApiApplication::Update
        flash[:success] = _('Admin|API Application|Successfully updated')
        redirect_to admin_api_applications_path
      else
        add_breadcrumb model.name
        flash[:danger] = _('Admin|API Application|Update failed')
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::ApiApplication::Destroy
        flash[:success] = _('Admin|API Application|Successfully deleted')
      else
        flash[:danger] = _('Admin|API Application|Cannot be deleted')
      end

      redirect_to admin_api_applications_path
    end
  end
end
