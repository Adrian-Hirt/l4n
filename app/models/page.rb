class Page < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :menu_items, dependent: :destroy

  # == Validations =================================================================
  validates :title, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates :url, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-z0-9]{1}[a-z0-9\-_]*\z/ }, length: { maximum: 255 }
  validates_boolean :published

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def readable?
    published? && FeatureFlag.enabled?(:pages)
  end

  # == Private Methods =============================================================
end
