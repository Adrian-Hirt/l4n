class TicketUpgrade < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :lan_party
  belongs_to :to_product, class_name: 'Product'
  belongs_to :from_product, class_name: 'Product'
  belongs_to :order

  # == Validations =================================================================
  validates_boolean :used

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def name
    "#{from_product.seat_category.name} -> #{to_product.seat_category.name}"
  end

  # == Private Methods =============================================================
end
