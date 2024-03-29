class CartItem < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :cart
  belongs_to :product_variant

  delegate :product, to: :product_variant

  # == Validations =================================================================
  validates :quantity, numericality: { greater_than: 0, less_than: MAX_PERMITTED_INT, integer_only: true }

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def total
    product_variant.price * quantity
  end

  # == Private Methods =============================================================
end
