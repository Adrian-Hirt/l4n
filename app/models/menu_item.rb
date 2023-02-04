class MenuItem < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================
  TYPES = %w[MenuLinkItem MenuDropdownItem].freeze

  # == Associations ================================================================

  # == Validations =================================================================
  validates :sort, numericality: { min: 0 }, presence: true
  validates_boolean :visible
  validates :title, presence: true, length: { maximum: 255 }
  validates :type, inclusion: TYPES

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
