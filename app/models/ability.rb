# rubocop:disable Style/GuardClause
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

    # Tournament permissions. No permissions if the feature flag is
    # not enabled.
    if FeatureFlag.enabled?(:tournaments)
      # Anyone can view all published tournaments
      can :read, Tournament, status: Tournament.statuses[:published]

      # Anyone can view any team that participates in a published tournament
      can :read, Tournament::Team, Queries::Tournament::Team::FetchAccessibleBy.call(user: user) do |m|
        m.tournament.published?
      end

      # Anyone can view any match that is in a published tournament
      can :read, Tournament::Match, Queries::Tournament::Match::FetchAccessibleBy.call(user: user) do |m|
        m.tournament.published?
      end
    end

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

    # Tournament permissions
    if FeatureFlag.enabled?(:tournaments)
      # A registered user can create a team
      can :create, Tournament::Team

      # A user can update a team if they are the captain of the team
      can :update, Tournament::Team do |m|
        m.captain?(user)
      end

      # A user can destroy a team if it's deletable and they are the captain
      can :destroy, Tournament::Team do |m|
        m.captain?(user) && m.deletable?
      end

      # A user can always join a Team
      can :create, Tournament::TeamMember

      # A user can update a TeamMember if it's in a team they are
      # the captain or if it's their own membership.
      can %i[read update destroy], Tournament::TeamMember do |m|
        m.user == user || m.team.captain?(user)
      end

      # Can update a match if captain of either teams
      can :update, Tournament::Match do |m|
        m.home.team.captain?(user) || m.away.team.captain?(user)
      end
    end

    ##############################################################
    # Admin Permissions
    ##############################################################

    # Return early if the user doesn't have any admin permission
    return unless user.any_admin_permission?

    # User can access admin panel if the user has any
    # admin permission
    can :access, :admin_panel

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
      can %i[read update], Ticket
    end

    # Tournament system permissions. For now we don't use fine-grained permissions,
    # and just allow a tournament admin to do everything.
    if user.tournament_admin_permission? && FeatureFlag.enabled?(:tournaments)
      can :manage, Tournament
      can :manage, Tournament::Phase
      can :manage, Tournament::Team
      can :manage, Tournament::Match
      can :manage, Tournament::TeamMember
    end
  end
end
# rubocop:enable Style/GuardClause
