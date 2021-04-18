class EventDate < ApplicationRecord
  belongs_to :event

  validates :start_date, presence: true

  scope :future, -> { where('(start_date >= ?) OR (start_date <= ? AND end_date >= ?)', Time.zone.today, Time.zone.today, Time.zone.today) }
end
