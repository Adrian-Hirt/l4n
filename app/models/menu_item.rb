class MenuItem < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================
  TYPES = %w[MenuLinkItem MenuDropdownItem].freeze

  # == Associations ================================================================
  belongs_to :page, optional: true, inverse_of: :menu_items

  # == Validations =================================================================
  validates :sort, numericality: { greater_than_or_equal_to: 0, less_than: MAX_PERMITTED_INT, integer_only: true }, presence: true
  validates_boolean :visible
  validates :title, presence: true, length: { maximum: 255 }
  validates :type, inclusion: TYPES

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
