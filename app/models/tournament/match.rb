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

  # == Associations ================================================================
  belongs_to :round, class_name: 'Tournament::Round', foreign_key: :tournament_round_id, inverse_of: :matches
  belongs_to :home, class_name: 'Tournament::PhaseTeam', optional: true
  belongs_to :away, class_name: 'Tournament::PhaseTeam', optional: true
  belongs_to :winner, class_name: 'Tournament::PhaseTeam', optional: true

  delegate :phase, to: :round
  delegate :tournament, to: :phase

  # == Validations =================================================================
  validates_boolean :draw
  validates :draw, absence: true, if: -> { winner.present? }

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

  # == Private Methods =============================================================
end
