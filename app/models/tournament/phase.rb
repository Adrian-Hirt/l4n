class Tournament::Phase < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :tournament
  has_many :rounds, class_name: 'Tournament::Round', foreign_key: :tournament_phase_id, dependent: :destroy, inverse_of: :phase

  # == Validations =================================================================
  validates :name, presence: true, length: { maximum: 255 }
  validates :phase_number, presence: true, numericality: { greater_than: 0 }
  validates :tournament_mode, presence: true

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
