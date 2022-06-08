class Promotion < ApplicationRecord
  # == Attributes ==================================================================
  enum code_type: {
    free_item:   'free_item',
    fixed_value: 'fixed_value'
  }

  monetize :reduction_cents, allow_nil: true

  # == Constants ===================================================================

  # == Associations ================================================================

  # == Validations =================================================================
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates :active, inclusion: [true, false]
  validates :code_type, presence: true
  validates :code_prefix, length: { maximum: 20 }
  validates :reduction, presence: true, if: -> { fixed_value? }
  validates :reduction, absence: true, if: -> { free_item? }

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
