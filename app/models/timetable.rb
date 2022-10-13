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
  validate :all_entries_within

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def times_set?
    start_datetime.present? && end_datetime.present?
  end

  # == Private Methods =============================================================
  private

  # Check that all defined entries lie within the bounds
  def all_entries_within
    # Early return if no entries
    return if timetable_entries.none?

    errors.add(:start_datetime, 'Timetable|Found entries before start') if timetable_entries.any? { |entry| entry.entry_start < start_datetime }

    errors.add(:end_datetime, 'Timetable|Found entries after end') if timetable_entries.any? { |entry| entry.entry_end > end_datetime }
  end
end
