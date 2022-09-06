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
    matches.all? { |match| match.winner.present? }
  end

  # == Private Methods =============================================================
end
