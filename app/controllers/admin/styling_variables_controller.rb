module Admin
  class StylingVariablesController < AdminController
    add_breadcrumb _('Admin|StylingVariables'), :admin_styling_variables_path

    def index
      op Operations::Admin::StylingVariable::Index
    end

    def new
      op Operations::Admin::StylingVariable::Create
      add_breadcrumb _('Admin|StylingVariable|New')
    end

    def create
      if run Operations::Admin::StylingVariable::Create
        flash[:success] = _('Admin|StylingVariable|Successfully created')
        redirect_to admin_styling_variables_path
      else
        add_breadcrumb _('Admin|StylingVariable|Edit')
        flash[:danger] = _('Admin|StylingVariable|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::StylingVariable::Update
      add_breadcrumb _('Admin|StylingVariable|Edit')
    end

    def update
      if run Operations::Admin::StylingVariable::Update
        flash[:success] = _('Admin|StylingVariable|Successfully updated')
        redirect_to admin_styling_variables_path
      else
        add_breadcrumb _('Admin|StylingVariable|Edit')
        flash[:danger] = _('Admin|StylingVariable|Edit failed')
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::StylingVariable::Destroy
        flash[:success] = _('Admin|StylingVariable|Successfully deleted')
      else
        flash[:danger] = _('Admin|StylingVariable|Cannot be deleted')
      end
      redirect_to admin_styling_variables_path
    end
  end
end
