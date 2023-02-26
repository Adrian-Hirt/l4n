class TimetableCategory < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :timetable, touch: true
  has_many :timetable_entries, dependent: :destroy

  # == Validations =================================================================
  validates :name, presence: true, length: { maximum: 255 }
  validates :order, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: MAX_PERMITTED_INT, integer_only: true }

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
