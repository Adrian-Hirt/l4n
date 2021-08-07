class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    # NewsPost admin permission
    can :manage, NewsPost if user.news_admin_permission?

    # Event admin permission
    can :manage, Event if user.event_admin_permission?

    # User admin permission
    can :manage, User if user.user_admin_permission?

    # User can access admin panel if the user has any
    # admin permission
    can :access, :admin_panel if user.any_admin_permission?

    can :update_profile, User do |m|
      m == user
    end

    can :update_profile, User do |m|
      m == user
    end

    can :destroy_my_user, User do |m|
      m == user
    end
  end
end
