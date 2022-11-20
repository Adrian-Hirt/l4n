module Admin
  class UserAchievementsController < AdminController
    add_breadcrumb _('Admin|Achievements'), :admin_achievements_path

    def new
      op Operations::Admin::UserAchievement::Create
      add_breadcrumb op.achievement.title, admin_achievement_path(op.achievement)
      add_breadcrumb _('Admin|UserAchievement|New')
    end

    def create
      if run Operations::Admin::UserAchievement::Create
        flash[:success] = _('Admin|UserAchievement|Successfully created')
        redirect_to admin_achievement_path(op.achievement)
      else
        add_breadcrumb op.achievement.title, admin_achievement_path(op.achievement)
        add_breadcrumb _('Admin|UserAchievement|New')
        flash[:danger] = _('Admin|UserAchievement|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::UserAchievement::Destroy
        flash[:success] = _('Admin|UserAchievement|Successfully deleted')
      else
        flash[:danger] = _('Admin|UserAchievement|Cannot be deleted')
      end

      redirect_to admin_achievement_path(model)
    end
  end
end
