class EventDate < ApplicationRecord
  belongs_to :event

  validates :start_date, presence: true
end
