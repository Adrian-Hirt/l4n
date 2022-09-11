class Tournament::Team < ApplicationRecord
  # == Attributes ==================================================================
  enum status: {
    created:     'created',
    registered:  'registered',
    seeded:      'seeded',
    playing:     'playing',
    dropped_out: 'dropped_out'
  }

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :tournament
  has_many :phase_teams, class_name: 'Tournament::PhaseTeam', foreign_key: :tournament_team_id, dependent: :destroy, inverse_of: :team
  has_many :phases, through: :phase_teams
  has_many :team_members, class_name: 'Tournament::TeamMember', foreign_key: :tournament_team_id, dependent: :destroy, inverse_of: :team
  has_many :users, through: :team_members

  # == Validations =================================================================
  validates :status, presence: true, inclusion: statuses.keys
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { scope: :tournament, case_insensitive: true }

  # == Hooks =======================================================================
  before_destroy :check_deletable?

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

  def deletable?
    created?
  end

  # == Private Methods =============================================================
  private

  def check_deletable?
    return if deletable?

    throw :abort
  end
end
