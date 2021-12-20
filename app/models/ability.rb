class Ability
  include CanCan::Ability

  def initialize(user)
    ##############################################################
    # Default Permissions
    ##############################################################

    # Anyone can read a newspost if the feature flag is enabled
    can :read, NewsPost, &:published? if FeatureFlag.enabled?(:news_posts)

    # Anyone can read an event if the feature flag is enabled
    can :read, Event, &:published? if FeatureFlag.enabled?(:events)

    # Return early if user does not exist
    return if user.nil?

    ##############################################################
    # Admin Permissions
    ##############################################################

    # NewsPost admin permission
    can :manage, NewsPost if user.news_admin_permission? && FeatureFlag.enabled?(:news_posts)

    # Event admin permission
    can :manage, Event if user.event_admin_permission? && FeatureFlag.enabled?(:events)

    # User admin permission
    can :manage, User if user.user_admin_permission?

    # Pages admin permission
    can :manage, Page

    # User can access system settings
    can :manage, FeatureFlag if user.system_admin_permission?

    # User can access admin panel if the user has any
    # admin permission
    can :access, :admin_panel if user.any_admin_permission?

    ##############################################################
    # User profile
    ##############################################################
    can :destroy_my_user, User do |m|
      m == user
    end
  end
end
