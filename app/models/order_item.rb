class OrderItem < ApplicationRecord
  # == Attributes ==================================================================
  monetize :price_cents

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :order
  belongs_to :product_variant, optional: true

  delegate :product, to: :product_variant, allow_nil: true

  # == Validations =================================================================
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: MAX_PERMITTED_INT, integer_only: true }

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def total
    price * quantity
  end

  # == Private Methods =============================================================#
end
