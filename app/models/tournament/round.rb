class Tournament::Round < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :phase, class_name: 'Tournament::Phase', foreign_key: :tournament_phase_id, inverse_of: :rounds
  has_many :matches, class_name: 'Tournament::Match', foreign_key: :tournament_round_id, dependent: :destroy, inverse_of: :round

  # == Validations =================================================================
  validates :round_number, presence: true, numericality: { greater_than: 0 }

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def completed?
    matches.all?(&:result_confirmed?)
  end

  def first_round?
    self == phase.rounds.order(:round_number).first
  end

  def last_round?
    self == phase.rounds.order(:round_number).last
  end

  # A lower bracket only round only has matches in the lower
  # bracket. This is the case if the round_number is odd and
  # not 1 (the first round always only has matches in the upper
  # bracket).
  def lower_bracket_only?
    round_number != 1 && round_number.odd?
  end

  def upper_bracket_only?
    round_number == 1 || self == phase.rounds.order(:round_number).last
  end

  # == Private Methods =============================================================
end
