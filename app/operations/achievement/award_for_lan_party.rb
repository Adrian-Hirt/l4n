module Operations::Achievement
  class AwardForLanParty < RailsOps::Operation
    schema3 do
      obj? :user
      obj? :lan_party
    end

    # Internal use only
    without_authorization

    def perform
      # Lookup if there's an achievement for the current lan
      lan_achievement = ::Achievement.find_by(lan_party: osparams.lan_party)

      # Return if there's no achievement
      return if lan_achievement.nil?

      # Check that the user does not have the achievement already
      return if UserAchievement.find_by(user: osparams.user, achievement: lan_achievement).present?

      # Otherwise create the UserAchievement
      user_achievement = UserAchievement.new(
        user:        osparams.user,
        achievement: lan_achievement,
        awarded_at:  Time.zone.now
      )

      user_achievement.save!
    end
  end
end
