class Page < ApplicationRecord
  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :url, presence: true, uniqueness: { case_sensitive: false }
  validates :published, inclusion: [true, false]
end
