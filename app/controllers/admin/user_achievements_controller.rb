module Admin
  class UserAchievementsController < AdminController
    add_breadcrumb _('Admin|Achievements'), :admin_achievements_path

    def new
      op Operations::Admin::UserAchievement::Create
      add_breadcrumb op.achievement.title, admin_achievement_path(op.achievement)
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('UserAchievement') }
    end

    def create
      if run Operations::Admin::UserAchievement::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('UserAchievement') }
        redirect_to admin_achievement_path(op.achievement)
      else
        add_breadcrumb op.achievement.title, admin_achievement_path(op.achievement)
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('UserAchievement') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('UserAchievement') }
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::UserAchievement::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('UserAchievement') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('UserAchievement') }
      end

      redirect_to admin_achievement_path(model)
    end
  end
end
