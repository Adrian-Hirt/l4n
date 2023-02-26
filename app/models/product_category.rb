class ProductCategory < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :products, dependent: :destroy

  # == Validations =================================================================
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates :sort, numericality: { greater_than_or_equal_to: 0, less_than: MAX_PERMITTED_INT, integer_only: true }, presence: true

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
