module Admin
  class StylingVariablesController < AdminController
    add_breadcrumb _('Admin|StylingVariables'), :admin_styling_variables_path

    def index
      op Operations::Admin::StylingVariable::Index
    end

    def new
      op Operations::Admin::StylingVariable::Create
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('StylingVariable') }
    end

    def create
      if run Operations::Admin::StylingVariable::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('StylingVariable') }
        redirect_to admin_styling_variables_path
      else
        add_breadcrumb _('Admin|%{model_name}|Edit') % { model_name: _('StylingVariable') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('StylingVariable') }
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::StylingVariable::Update
      add_breadcrumb _('Admin|%{model_name}|Edit') % { model_name: _('StylingVariable') }
    end

    def update
      if run Operations::Admin::StylingVariable::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('StylingVariable') }
        redirect_to admin_styling_variables_path
      else
        add_breadcrumb _('Admin|%{model_name}|Edit') % { model_name: _('StylingVariable') }
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('StylingVariable') }
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::StylingVariable::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('StylingVariable') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('StylingVariable') }
      end
      redirect_to admin_styling_variables_path
    end
  end
end
