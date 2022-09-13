class Tournament::PhaseTeam < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :phase, class_name: 'Tournament::Phase', foreign_key: :tournament_phase_id, inverse_of: :phase_teams
  belongs_to :team, class_name: 'Tournament::Team', foreign_key: :tournament_team_id, inverse_of: :phase_teams

  delegate :name, to: :team

  # == Validations =================================================================
  validates :seed, presence: true, numericality: { greater_than: 0 }

  # == Hooks =======================================================================

  # == Scopes ======================================================================
  scope :ordered_by_seed, -> { order('seed ASC') }

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
