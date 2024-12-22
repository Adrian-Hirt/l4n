class Tournament::Team < ApplicationRecord
  # == Attributes ==================================================================
  enum :status, {
    created:    'created',
    registered: 'registered',
    seeded:     'seeded'
  }

  translate_enums

  has_secure_password validations: false

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :tournament, touch: true
  belongs_to :tournament_team_rank, class_name: 'Tournament::TeamRank', optional: true
  has_many :phase_teams, class_name: 'Tournament::PhaseTeam', foreign_key: :tournament_team_id, dependent: :destroy, inverse_of: :team
  has_many :phases, through: :phase_teams
  has_many :team_members, class_name: 'Tournament::TeamMember', foreign_key: :tournament_team_id, dependent: :destroy, inverse_of: :team
  has_many :users, through: :team_members

  # == Validations =================================================================
  validates :status, presence: true, inclusion: statuses.keys
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { scope: :tournament, case_insensitive: true }

  # Validate that the ranks is set if the tournament wants the rank to be set
  validates :tournament_team_rank, presence: true, if: -> { tournament&.teams_need_rank? }

  # Password validations only relevant for multiplayer games
  validates :password, presence: true, length: { minimum: 6, maximum: 72 }, if: -> { !tournament&.singleplayer? && (password.present? || new_record?) }

  # == Hooks =======================================================================

  # == Scopes ======================================================================
  scope :in_tournament, -> { where.not(status: 'created') }
  scope :not_in_tournament, -> { where(status: 'created') }
  scope :singleplayer, -> { joins(:tournament).where(tournament: { singleplayer: true }) }

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def full?
    team_members.count >= tournament.team_size
  end

  def captain_missing?
    team_members.none?(&:captain?)
  end

  def deleteable?
    if tournament.singleplayer?
      registered?
    else
      created?
    end
  end

  def captain
    team_members.find_by(captain: true)
  end

  def captain?(user)
    captain.present? && user.present? && captain.user_id == user.id
  end

  def name_with_optional_rank
    if tournament_team_rank.blank?
      name
    else
      "#{name} - #{tournament_team_rank.name}"
    end
  end

  # == Private Methods =============================================================
end
