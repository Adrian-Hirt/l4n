# rubocop:disable Style/GuardClause
# rubocop:disable Metrics/ClassLength
class Ability
  include CanCan::Ability

  def initialize(user)
    ##############################################################
    # Default Permissions
    ##############################################################
    # Anyone can read a newspost if the feature flag is enabled and it's published
    can :read_public, NewsPost, &:published? if FeatureFlag.enabled?(:news_posts)

    # Anyone can read an event if the feature flag is enabled and it's published
    can :read_public, Event, &:published? if FeatureFlag.enabled?(:events)

    # Anyone can read a page if the feature flag is enabled and it's published
    # if it's a content page, or in any case if it's a redirect page
    if FeatureFlag.enabled?(:pages)
      can :read_public, Page do |m|
        m.is_a?(RedirectPage) || m.published?
      end
    end

    if FeatureFlag.enabled?(:lan_party)
      # Anyone can read a lanparty if it's active
      can :read_public, LanParty, &:active

      # Anyone can look at the seatmap and the timetable if it's enabled
      can :read_public, SeatMap, lan_party: { seatmap_enabled: true, active: true }
      can :read_public, Timetable, lan_party: { timetable_enabled: true, active: true }
    end

    if FeatureFlag.enabled?(:shop)
      can :read_public, :shop
      can :read_public, Product, &:on_sale
    end

    # Tournament permissions. No permissions if the feature flag is
    # not enabled.
    if FeatureFlag.enabled?(:tournaments)
      # Anyone can view all published tournaments
      can :read_public, Tournament, status: Tournament.statuses[:published]

      # Anyone can view any team that participates in a published tournament
      can :read_public, Tournament::Team, Queries::Tournament::Team::FetchAccessibleBy.call(user: user) do |m|
        m.tournament.published?
      end

      # Anyone can view any match that is in a published tournament
      can :read_public, Tournament::Match, Queries::Tournament::Match::FetchAccessibleBy.call(user: user) do |m|
        m.tournament.published?
      end
    end

    # Anyone can read user list and profiles
    can :read_public, User

    # Return early if user does not exist
    return if user.nil?

    ##############################################################
    # User Permissions
    ##############################################################
    # Shop permissions
    if FeatureFlag.enabled?(:shop)
      can :use, :shop
      can :read_public, Order do |m|
        m.user == user
      end
    end

    # User profile
    can :destroy_my_user, User do |m|
      m == user
    end

    # Any logged in user can use the seatmap
    can :use, SeatMap if FeatureFlag.enabled?(:lan_party)

    # A user can use their tickets to reserve seats
    can :use, Ticket do |m|
      m.order&.user == user || m.assignee == user
    end

    # A user can only use the ticket_upgrades they own
    can :use, TicketUpgrade do |m|
      m.order&.user == user
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
        m.captain?(user) && m.deleteable?
      end

      # A user can always join a Team
      can :create, Tournament::TeamMember

      # A user can update a TeamMember if it's in a team they are
      # the captain or if it's their own membership.
      can %i[read_public update destroy], Tournament::TeamMember do |m|
        m.user == user || m.team.captain?(user)
      end

      # Can update a match score if captain of either teams
      can :update_score, Tournament::Match do |m|
        m.home.team.captain?(user) || m.away.team.captain?(user)
      end
    end

    ##############################################################
    # Admin Permissions
    ##############################################################
    # Return early if the user doesn't have any admin permission
    # and doesn't have any fine-grained admin permission (e.g.
    # to edit a single tournament)
    return unless user.any_admin_permission? || user.any_fine_grained_admin_permission?

    # User can access admin panel if the user has any
    # admin permission or any fine-grained admin permission
    can :access, :admin_panel

    # An user may update a tournament, manage its registrations,
    # phases, rounds and matches if they have the "fine-grained"
    # permission for that tournament
    if FeatureFlag.enabled?(:tournaments) && user.user_tournament_permissions.any?
      can %i[read update], Tournament, permitted_users: { id: user.id }
      can :manage, Tournament::Phase, tournament: Tournament.accessible_by(self)
      can :manage, Tournament::Team, tournament: Tournament.accessible_by(self)
      can :manage, Tournament::TeamMember, team: Tournament::Team.accessible_by(self)
      can %i[read update], Tournament::Match, round: { phase: Tournament::Phase.accessible_by(self) }
    end

    # Return early if the user only has fine-grained admin permissions
    # but no other admin permissions
    return unless user.any_admin_permission?

    # NewsPost admin permission
    can :manage, NewsPost if FeatureFlag.enabled?(:news_posts) && user.permission_for?(:news_admin, :manage)

    # Event admin permission
    # can :manage, Event if user.event_admin_permission? && FeatureFlag.enabled?(:events)
    can :manage, Event if FeatureFlag.enabled?(:events) && user.permission_for?(:event_admin, :manage)

    # User admin permission
    if user.permission_for?(:user_admin, :manage)
      can :manage, User
    elsif user.permission_for?(:user_admin, :readonly)
      can :read, User
    end

    # Pages admin permission
    can :manage, Page if FeatureFlag.enabled?(:pages) && user.permission_for?(:page_admin, :manage)

    # Menu items permission
    can :manage, MenuItem if user.permission_for?(:menu_item_admin, :manage)

    # User can use the payment assist
    can :use, :payment_assist if FeatureFlag.enabled?(:shop) && user.permission_for?(:payment_assist, :use)

    # Shop permissions. For now, we group the models related to the shop
    # together, as we probably don't need a too fine-grained access control
    # for the shop, i.e. users that can create products can also see orders
    if FeatureFlag.enabled?(:shop) && user.permission_for?(:shop_admin, :manage)
      can :manage, :shop
      can :manage, Product
      can :manage, ProductCategory
      can :manage, Promotion
      can :manage, PromotionCode
      can :manage, Order
    end

    # Lan party permissions. For now we don't use fine-grained permissions,
    # and just allow a lan party admin to do everything.
    if FeatureFlag.enabled?(:lan_party)
      if user.permission_for?(:lan_party_admin, :readonly)
        can :read, LanParty
        can :read, SeatCategory
        can :read, SeatMap
        can :read, ScannerUser
        can :read, Ticket
        can :read, TicketUpgrade
        can :read, Timetable
      elsif user.permission_for?(:lan_party_admin, :manage)
        can :manage, LanParty
        can :manage, SeatCategory
        can :manage, SeatMap
        can :manage, ScannerUser
        can %i[create read update], Ticket
        can :read, TicketUpgrade
        can :manage, Timetable
        can :manage, TimetableCategory
        can :manage, TimetableEntry
      end
    end

    # Tournament system permissions. For now we don't use fine-grained permissions,
    # and just allow a tournament admin to do everything.
    if FeatureFlag.enabled?(:tournaments) && user.permission_for?(:tournament_admin, :manage)
      can :manage, Tournament
      can :manage, Tournament::Phase
      can :manage, Tournament::Team
      can %i[read update], Tournament::Match
      can :manage, Tournament::TeamMember
    end

    # Design permissions (styling, footer logos etc.)
    if user.permission_for?(:design_admin, :manage)
      can :manage, :frontent_design
      can :manage, FooterLogo
      can :manage, SidebarBlock
      can :manage, StylingVariable
      can :manage, StartpageBanner
      can :manage, StartpageBlock
    end

    # Achievement permissions
    if user.permission_for?(:achievement_admin, :manage)
      can :manage, Achievement
      can :manage, UserAchievement
    end

    # Uploading files
    if user.permission_for?(:upload_admin, :readonly)
      can :read, Upload
    elsif user.permission_for?(:upload_admin, :manage)
      can :manage, Upload
    end

    # System admin permission, for actions such as clearing the cache and
    # feature flags. This permission should only be given very carefully
    if user.permission_for?(:system_admin, :manage)
      can :manage, :system
      can :manage, AppConfig
      can :manage, FeatureFlag
    end

    # Access to stuff needed for developers, such as Api & OAuth applications
    if FeatureFlag.enabled?(:api_and_oauth)
      if user.permission_for?(:developer_admin, :readonly)
        can :read, :developer
        can :read, ApiApplication
        can :read, Doorkeeper::Application
      elsif user.permission_for?(:developer_admin, :manage)
        can :manage, :developer
        can :manage, ApiApplication
        can :manage, Doorkeeper::Application
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
# rubocop:enable Style/GuardClause
