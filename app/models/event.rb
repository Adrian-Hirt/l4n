class Event < ApplicationRecord
  has_many :event_dates, dependent: :destroy

  validates :title, presence: true
end
