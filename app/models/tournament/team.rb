class Tournament::Team < ApplicationRecord
  # == Attributes ==================================================================
  enum status: {
    created:    'created',
    registered: 'registered',
    accepted:   'accepted'
  }

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :tournament
  has_many :phase_teams, class_name: 'Tournament::PhaseTeam', foreign_key: :tournament_phase_id, dependent: :destroy, inverse_of: :team
  has_many :phases, through: :phase_teams

  # == Validations =================================================================
  validates :status, presence: true, inclusion: statuses.keys
  validates :name, presence: true, length: { maximum: 255 }

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
