module Admin
  class ApiApplicationsController < AdminController
    add_breadcrumb _('Admin|API Applications'), :admin_api_applications_path

    def index
      op Operations::Admin::ApiApplication::Index
    end

    def new
      op Operations::Admin::ApiApplication::Create
      add_breadcrumb _('Admin|API Applications|New')
    end

    def create
      if run Operations::Admin::ApiApplication::Create
        flash[:success] = _('Admin|API Applications|Successfully created')
        redirect_to edit_admin_api_application_path(model)
      else
        add_breadcrumb _('Admin|API Applications|New')
        flash[:danger] = _('Admin|API Applications|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::ApiApplication::Update
      add_breadcrumb model.name
    end

    def update
      if run Operations::Admin::ApiApplication::Update
        flash[:success] = _('Admin|API Applications|Successfully updated')
        redirect_to admin_api_applications_path
      else
        add_breadcrumb model.name
        flash[:danger] = _('Admin|API Applications|Update failed')
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::ApiApplication::Destroy
        flash[:success] = _('Admin|API Applications|Successfully deleted')
      else
        flash[:danger] = _('Admin|API Applications|Cannot be deleted')
      end

      redirect_to admin_api_applications_path
    end
  end
end
