class Tournament < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :phases, class_name: 'Tournament::Phase', dependent: :destroy
  has_many :teams, dependent: :destroy

  # == Validations =================================================================
  validates :name, presence: true, length: { maximum: 255 }
  validates :team_size, presence: true, numericality: { greater_than: 0 }

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  # Another phase only possible if the phase is either the first phase, or the
  # previous phase is either swiss or round_robin. For single and double elim,
  # we only have one winner and as such it does not make sense to have another round
  # after that.
  def another_phase_possible?
    return true if phases.none?

    previous_round = phases.order(phase_number: :desc).first

    previous_round.swiss? # || previous_round.round_robin?
  end

  # == Private Methods =============================================================
end
