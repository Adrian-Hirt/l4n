class Tournament::TeamRank < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :tournament
  has_many :tournament_teams, dependent:   :restrict_with_error,
                              class_name:  'Tournament::Team',
                              foreign_key: :tournament_team_rank_id,
                              inverse_of:  :tournament_team_rank

  # == Validations =================================================================
  validates :name, presence: true, uniqueness: { scope: :tournament, case_sensitive: false }, length: { maximum: 255 }
  validates :sort, numericality: { min: 0 }, presence: true

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
