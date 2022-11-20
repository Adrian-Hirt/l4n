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
      add_breadcrumb _('Admin|Achievement|New')
    end

    def create
      if run Operations::Admin::Achievement::Create
        flash[:success] = _('Admin|Achievement|Successfully created')
        redirect_to admin_achievements_path
      else
        add_breadcrumb _('Admin|Achievement|New')
        flash[:danger] = _('Admin|Achievement|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::Achievement::Update
      add_breadcrumb model.title
    end

    def update
      if run Operations::Admin::Achievement::Update
        flash[:success] = _('Admin|Achievement|Successfully updated')
        redirect_to admin_achievements_path
      else
        add_breadcrumb model.title
        flash[:danger] = _('Admin|Achievement|Update failed')
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::Achievement::Destroy
        flash[:success] = _('Admin|Achievement|Successfully deleted')
      else
        flash[:danger] = _('Admin|Achievement|Cannot be deleted')
      end

      redirect_to admin_achievements_path
    end
  end
end
