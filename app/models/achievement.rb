class Achievement < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :user_achievements, dependent: :destroy
  has_many :users, through: :user_achievements
  belongs_to :lan_party, optional: true

  has_one_attached :icon do |attachable|
    attachable.variant :small, resize_to_fill: [32, 32]
    attachable.variant :medium, resize_to_fill: [64, 64]
  end

  # == Validations =================================================================
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 255 }
  validates :lan_party, uniqueness: true, if: :lan_party

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
