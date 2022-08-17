class Tournament::Match < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================

  # == Validations =================================================================
  belongs_to :round, class_name: 'Tournament::Round', foreign_key: :tournament_round_id, inverse_of: :matches
  belongs_to :home_team, class_name: 'Tournament::Team', optional: true
  belongs_to :away_team, class_name: 'Tournament::Team', optional: true
  belongs_to :winner, class_name: 'Tournament::Team', optional: true

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
