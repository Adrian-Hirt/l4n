# {ProductVariant} stores a variant of a product, with an associated price of that variant.
class ProductVariant < ApplicationRecord
  # == Attributes ==================================================================
  monetize :price_cents

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :product
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :nullify

  # == Validations =================================================================
  validates :name, presence: true, length: { maximum: 255 }

  # == Hooks =======================================================================
  before_destroy :check_no_orders_in_payment

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
  private

  def check_no_orders_in_payment
    return unless order_items.joins(:order).where(orders: { status: Order.statuses[:payment_pending] }).any?

    errors.add(:base, _('ProductVariant|Cannot delete as an order in payment has this variant'))
    throw :abort
  end
end
