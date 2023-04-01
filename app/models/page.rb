class Page < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================
  TYPES = %w[ContentPage RedirectPage].freeze

  # == Associations ================================================================
  has_many :menu_items, dependent: :destroy, foreign_key: 'page_id', inverse_of: :page

  # == Validations =================================================================
  validates :url, presence: true, uniqueness: { case_sensitive: false }, format: { with: %r{\A[a-z0-9]{1}[a-z0-9\-_./]*\z} }, length: { maximum: 255 }
  validates :type, inclusion: TYPES

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
