class Tournament::Match < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================
  # Awarded scores for match results, the scores are as follows:
  #   * Win => 2 points
  #   * Draw => 1 Point
  #   * Loss => 0 Point
  #   * Bye => 1 point
  #   * Forfeited => 0 Points
  WIN_SCORE = 2
  DRAW_SCORE = 1
  LOSS_SCORE = 0
  BYE_SCORE = 1
  FORFEITED_SCORE = 0

  # Statuses for the results
  enum result_status: {
    missing:   'missing',   # No result reported so far
    reported:  'reported',  # Result reported by one team captain
    confirmed: 'confirmed', # Result confirmed by other team captain
    disputed:  'disputed'   # Result disputed by other team captain
  }, _prefix: :result

  translate_enums

  # == Associations ================================================================
  belongs_to :round, class_name: 'Tournament::Round', foreign_key: :tournament_round_id, inverse_of: :matches, touch: true
  belongs_to :home, class_name: 'Tournament::PhaseTeam', optional: true
  belongs_to :away, class_name: 'Tournament::PhaseTeam', optional: true
  belongs_to :winner, class_name: 'Tournament::PhaseTeam', optional: true
  belongs_to :reporter, class_name: 'Tournament::PhaseTeam', optional: true

  delegate :phase, to: :round
  delegate :tournament, to: :phase

  # == Validations =================================================================
  validates_boolean :draw
  validates :draw, absence: true, if: -> { winner.present? }
  validates :home_score, presence: true, numericality: { greater_or_equal_to: 0 }
  validates :away_score, presence: true, numericality: { greater_or_equal_to: 0 }
  validates :result_status, presence: true, inclusion: result_statuses.keys

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def bye?
    winner.present && away.blank?
  end

  def result_updateable?
    round == phase.current_round && away.present?
  end

  def loser
    return if winner.blank?

    winner == away ? home : away
  end

  # == Private Methods =============================================================
end
