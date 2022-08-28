class Tournament::Phase < ApplicationRecord
  # == Attributes ==================================================================
  enum tournament_mode: {
    swiss:              'swiss',
    single_elimination: 'single_elimination',
    double_elimination: 'double_elimination'
  }

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :tournament
  has_many :rounds, class_name: 'Tournament::Round', foreign_key: :tournament_phase_id, dependent: :destroy, inverse_of: :phase
  has_many :phase_teams, class_name: 'Tournament::PhaseTeam', foreign_key: :tournament_phase_id, dependent: :destroy, inverse_of: :phase
  has_many :teams, through: :phase_teams
  has_many :seeded_teams, -> { order('tournament_phase_teams.seed') }, through: :phase_teams, source: :team
  has_many :matches, through: :rounds

  # == Validations =================================================================
  validates :name, presence: true, length: { maximum: 255 }
  validates :phase_number, presence: true, numericality: { greater_than: 0 }
  validates :tournament_mode, presence: true, inclusion: tournament_modes.keys

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def generator_class
    if swiss?
      TournamentSystem::Swiss
    elsif round_robin?
      TournamentSystem::RoundRobin
    elsif single_elimination?
      TournamentSystem::SingleElimination
    elsif double_elimination?
      TournamentSystem::DoubleElimination
    else
      fail 'Invalid tournament mode!'
    end
  end

  # == Private Methods =============================================================
end
