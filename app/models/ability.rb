class Ability
  include CanCan::Ability

  def initialize(user)
    ##############################################################
    # Default Permissions
    ##############################################################

    # Anyone can read a newspost if the feature flag is enabled and it's published
    can :read, NewsPost, &:published? if FeatureFlag.enabled?(:news_posts)

    # Anyone can read an event if the feature flag is enabled and it's published
    can :read, Event, &:published? if FeatureFlag.enabled?(:events)

    # Anyone can read a page if the feature flag is enabled and it's published
    can :read, Page, &:published? if FeatureFlag.enabled?(:pages)

    # Anyone can look at the seatmap if it's enabled
    can :read, SeatMap if FeatureFlag.enabled?(:lan_party)

    can :read, :shop if FeatureFlag.enabled?(:shop)

    # Return early if user does not exist
    return if user.nil?

    ##############################################################
    # User Permissions
    ##############################################################
    # Shop permissions
    if FeatureFlag.enabled?(:shop)
      can :use, :shop
      can :read, Order do |m|
        m.user == user
      end
    end

    # User addresses
    can :create, UserAddress
    can %i[read update destroy], UserAddress do |m|
      m.user == user
    end

    # User profile
    can :destroy_my_user, User do |m|
      m == user
    end

    # Any logged in user can use the seatmap
    can :use, SeatMap if FeatureFlag.enabled?(:lan_party)

    # A user can use their tickets to reserve seats
    can :use, Ticket do |m|
      m.order.user == user || m.assignee == user
    end

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
    can :manage, Page if user.page_admin_permission? && FeatureFlag.enabled?(:pages)

    # Menu items permission
    can :manage, MenuItem if user.menu_items_admin_permission?

    # User can access system settings
    can :manage, FeatureFlag if user.system_admin_permission?

    # User can use the payment assist TODO: add permission check
    can :use, :payment_assist

    # Shop permissions. For now, we group the models related to the shop
    # together, as we probably don't need a too fine-grained access control
    # for the shop, i.e. users that can create products can also see orders
    if user.shop_admin_permission? && FeatureFlag.enabled?(:shop)
      can :manage, :shop
      can :manage, Product
      can :manage, ProductCategory
      can :manage, Promotion
      can :manage, PromotionCode
      can :manage, Order
    end

    # Lan party permissions. For now we don't use fine-grained permissions,
    # and just allow a lan party admin to do everything.
    if user.lan_party_admin_permission && FeatureFlag.enabled?(:lan_party)
      can :manage, LanParty
      can :manage, SeatCategory
      can :manage, SeatMap
      can %i[view destroy], Ticket
    end

    # Tournament system permissions. For now we don't use fine-grained permissions,
    # and just allow a tournament admin to do everything.
    if user.tournament_admin_permission? && FeatureFlag.enabled?(:tournaments)
      can :manage, Tournament
      can :manage, Tournament::Phase
      can :manage, Tournament::Team
      can :manage, Tournament::Match
    end

    # User can access admin panel if the user has any
    # admin permission
    can :access, :admin_panel if user.any_admin_permission?
  end
end
