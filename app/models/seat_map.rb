class SeatMap < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :lan_party
  has_many :seats, dependent: :destroy

  # == Validations =================================================================
  validates :background_height, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: MAX_PERMITTED_INT, integer_only: true }
  validates :background_width, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: MAX_PERMITTED_INT, integer_only: true }
  validates :canvas_height, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: MAX_PERMITTED_INT, integer_only: true }
  validates :canvas_width, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: MAX_PERMITTED_INT, integer_only: true }

  # Background image
  has_one_attached :background

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
