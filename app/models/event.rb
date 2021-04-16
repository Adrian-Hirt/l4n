class Event < ApplicationRecord
  has_many :event_dates, dependent: :destroy
  accepts_nested_attributes_for :event_dates, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true
end
