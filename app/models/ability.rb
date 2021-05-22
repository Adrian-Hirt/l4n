class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, NewsPost
    can :read, Event

    if user&.activated?
      can :manage, :all
      can :access, :admin_panel
    end
  end
end
