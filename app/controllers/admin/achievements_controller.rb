module Admin
  class AchievementsController < AdminController
    add_breadcrumb _('Admin|Achievements'), :admin_achievements_path

    def index
      op Operations::Admin::Achievement::Index
    end

    def show
      op Operations::Admin::Achievement::Load
      add_breadcrumb model.title
    end

    def new
      op Operations::Admin::Achievement::Create
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Achievement') }
    end

    def create
      if run Operations::Admin::Achievement::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('Achievement') }
        redirect_to admin_achievements_path
      else
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Achievement') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('Achievement') }
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::Achievement::Update
      add_breadcrumb model.title
    end

    def update
      if run Operations::Admin::Achievement::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('Achievement') }
        redirect_to admin_achievements_path
      else
        add_breadcrumb model.title
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('Achievement') }
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::Achievement::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('Achievement') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('Achievement') }
      end

      redirect_to admin_achievements_path
    end
  end
end
