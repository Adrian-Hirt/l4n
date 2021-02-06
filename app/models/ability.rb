class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :manage, :all
      can :access, :admin_panel
    end

    can :read, NewsPost
  end
end
