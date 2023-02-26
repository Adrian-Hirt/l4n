class SidebarBlock < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================

  # == Validations =================================================================
  validates_boolean :visible
  validates :title, presence: true, length: { maximum: 30 }
  validates :sort, numericality: { greater_than_or_equal_to: 0, less_than: MAX_PERMITTED_INT, integer_only: true }, presence: true

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
