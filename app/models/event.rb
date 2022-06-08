class Event < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :event_dates, dependent: :destroy
  accepts_nested_attributes_for :event_dates, reject_if: :all_blank, allow_destroy: true

  # == Validations =================================================================
  validates :title, presence: true, length: { maximum: 255 }
  validates :published, inclusion: [true, false]
  validates :location, length: { maximum: 255 }
  validate :minimum_one_date

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def future_dates
    event_dates.future
  end

  def past_dates
    event_dates.past
  end

  def next_date
    future_dates.order('event_dates.start_date ASC').first
  end

  def last_date
    past_dates.order('event_dates.end_date DESC').first
  end

  # == Private Methods =============================================================
  private

  def minimum_one_date
    errors.add(:event_dates, _('Event|You need to add at least one date')) if event_dates.count < 1 && event_dates.empty?
  end
end
