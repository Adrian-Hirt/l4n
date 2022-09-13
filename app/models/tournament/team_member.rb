class Tournament::TeamMember < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :user
  belongs_to :team, class_name: 'Tournament::Team', foreign_key: :tournament_team_id, inverse_of: :team_members

  # == Validations =================================================================
  validates_boolean :captain
  validates :captain, uniqueness: { scope: :team }, if: :captain?

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
