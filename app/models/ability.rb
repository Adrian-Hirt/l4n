class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all if user

    can :access, :admin_panel
  end
end
