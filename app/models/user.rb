class User < ApplicationRecord
  # == Attributes ==================================================================
  devise :two_factor_backupable, :rememberable, :recoverable, :confirmable
  devise :two_factor_authenticatable, authentication_keys: %i[email]

  # == Constants ===================================================================
  PERMISSION_FIELDS = %i[
    user_admin_permission
    news_admin_permission
    event_admin_permission
    page_admin_permission
    menu_items_admin_permission
    shop_admin_permission
    payment_assist_admin_permission
    lan_party_admin_permission
    tournament_admin_permission
    design_admin_permission
    achievement_admin_permission
    upload_admin_permission
    developer_admin_permission
    system_admin_permission
  ].freeze

  # == Associations ================================================================
  # Avatar image
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
    attachable.variant :medium, resize_to_fill: [300, 300]
  end

  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :team_memberships, class_name: 'Tournament::TeamMember', dependent: :destroy, inverse_of: :user
  has_many :teams, through: :team_memberships
  has_many :tickets, foreign_key: :assignee_id, dependent: :nullify, inverse_of: :assignee
  has_many :user_achievements, dependent: :destroy
  has_many :user_tournament_permissions, dependent: :destroy
  has_many :permitted_tournaments, through: :user_tournament_permissions, source: :tournament

  # rubocop:disable Rails/InverseOf
  has_many :access_grants,
           class_name:  'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent:   :destroy

  has_many :access_tokens,
           class_name:  'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent:   :destroy
  # rubocop:enable Rails/InverseOf

  has_many :user_permissions, dependent: :destroy
  accepts_nested_attributes_for :user_permissions, allow_destroy: true

  # == Validations =================================================================
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }, length: { maximum: 255 }
  validates :password, presence: true, length: { minimum: 10, maximum: 72 }, if: -> { password.present? || new_record? }
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates_boolean :use_dark_mode
  validates :website, length: { maximum: 255 }
  validates :avatar, size: { less_than: 5.megabytes, message: _('File is too large, max. allowed %{size}') % { size: '5MB' } }, content_type: %r{\Aimage/.*\z}

  # Permission booleans
  PERMISSION_FIELDS.each do |field|
    validates_boolean field
  end

  # == Hooks =======================================================================
  before_save { self.email = email.downcase } # turns email to downcase for uniqueness
  after_update :update_singleplayer_teams

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def deleteable?
    false
  end

  def any_admin_permission?
    User::PERMISSION_FIELDS.any? { |permission| send(permission) }
  end

  def any_fine_grained_admin_permission?
    user_tournament_permissions.any?
  end

  def only_payment_assist_permission?
    # Return false if the user does not have the payment assist permission
    return false unless payment_assist_admin_permission?

    # Otherwise check if this is the only permission the user has
    User::PERMISSION_FIELDS.excluding(:payment_assist_admin_permission).none? { |permission| send(permission) }
  end

  def ticket_for(lan_party)
    tickets.find_by(lan_party: lan_party)
  end

  def tickets_for(lan_party)
    tickets.where(lan_party: lan_party)
  end

  # == Private Methods =============================================================
  private

  def update_singleplayer_teams
    return unless saved_change_to_attribute? :username

    teams.singleplayer.each do |team|
      team.name = username
      team.save!
    end
  end
end
