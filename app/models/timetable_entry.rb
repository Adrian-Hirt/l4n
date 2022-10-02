class TimetableEntry < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :timetable_category

  # == Validations =================================================================
  validates :title, presence: true, length: { maximum: 255 }
  validates :link, length: { maximum: 255 }
  validates :entry_start, presence: true
  validates :entry_end, presence: true, comparison: { greater_than: :entry_start }

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
