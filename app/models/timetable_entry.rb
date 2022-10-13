class TimetableEntry < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :timetable_category, touch: true
  delegate :timetable, to: :timetable_category

  # == Validations =================================================================
  validates :title, presence: true, length: { maximum: 255 }
  validates :link, length: { maximum: 255 }
  validates :entry_start, presence: true
  validates :entry_end, presence: true, comparison: { greater_than: :entry_start }
  validate :entry_end_sensible
  validate :within_timetable_bounds

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
  private

  # We want to have at least 1 hour between the start and the end (such that it's
  # properly rendered in the timetable).
  def entry_end_sensible
    # Don't do anything if either of the datetimes is not present
    return if entry_start.blank? || entry_end.blank?

    # Don't do anything if the datetimes are at least one hour apart
    return if entry_end - entry_start >= 1.hour

    errors.add(:entry_end, 'TimetableEntry|End should be at least 1 hour after start')
  end

  # Our entries should be within the bounds of the timetable
  def within_timetable_bounds
    # Don't do anything if the bounds of the timetable aren't set
    return unless timetable.times_set?

    # Check that the times lie within the timetable
    errors.add(:entry_start, 'TimetableEntry|Start before timetable start') if entry_start < timetable.start_datetime

    errors.add(:entry_end, 'TimetableEntry|End after timetable end') if entry_end > timetable.end_datetime
  end
end
