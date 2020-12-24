class Ability
  include CanCan::Ability

  def initialize(user)
    # rubocop:disable Style/GuardClause
    if user
      can :manage, :all
      can :access, :admin_panel
    end
    # rubocop:enable Style/GuardClause
  end
end
