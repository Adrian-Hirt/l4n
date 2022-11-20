module Operations::Admin::UserAchievement
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      int! :achievement_id, cast_str: true
      hsh? :user_achievement do
        str? :user_id
        str? :awarded_at
      end
    end

    model ::UserAchievement

    def perform
      model.awarded_at = Time.zone.now if osparams.user_achievement[:awarded_at].blank?
      model.achievement = achievement
      super
    end

    def achievement
      @achievement ||= ::Achievement.find(osparams.achievement_id)
    end

    def user_candidates
      @user_candidates ||= ::User.where.not(id: achievement.users).order(:username)
    end
  end
end
