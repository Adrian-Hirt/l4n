class Page < ApplicationRecord
  validates :title, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates :url, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-z0-9]{1}[a-z0-9\-_]*\z/ }, length: { maximum: 255 }
  validates :published, inclusion: [true, false]
end
