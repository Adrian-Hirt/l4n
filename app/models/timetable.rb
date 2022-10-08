class Timetable < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :lan_party
  has_many :timetable_categories, dependent: :destroy
  has_many :timetable_entries, through: :timetable_categories

  # == Validations =================================================================
  validates :lan_party, uniqueness: true
  validates :start_datetime, comparison: { less_than: :end_datetime }, if: :start_datetime

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def times_set?
    start_datetime.present? && end_datetime.present?
  end

  # == Private Methods =============================================================
end
