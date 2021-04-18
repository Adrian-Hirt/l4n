class Event < ApplicationRecord
  has_many :event_dates, dependent: :destroy
  accepts_nested_attributes_for :event_dates, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true

  def future_dates
    event_dates.future
  end

  def next_date
    future_dates.order('event_dates.start_date ASC, event_dates.start_time ASC').first
  end
end
