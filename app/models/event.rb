class Event < ApplicationRecord
  has_many :event_dates, dependent: :destroy
  accepts_nested_attributes_for :event_dates, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true
  validates :published, inclusion: [true, false]
  validate :minimum_one_date

  def future_dates
    event_dates.future
  end

  def past_dates
    event_dates.past
  end

  def next_date
    future_dates.order('event_dates.start_date ASC, event_dates.start_time ASC').first
  end

  def last_date
    past_dates.order('event_dates.end_date DESC, event_dates.end_time DESC').first
  end

  private

  def minimum_one_date
    errors.add(:base, _('Event|You need to add at least one date')) if event_dates.count < 1 && event_dates.empty?
  end
end