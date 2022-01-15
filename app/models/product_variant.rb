# {ProductVariant} stores a variant of a product, with an associated price and
#   availability of that variant.
#
# @!attribute inventory
#   @return [Integer] Number of "physically" present instances, i.e. not sold yet
#     and available for sale. This is only decreased when a checkout process is
#     completed
#
# @!attribute availability
#   @return [Integer] The number of product available to enter the checkout process.
#     When an user enters the checkout process, this is decreased, meaning the items
#     are on hold for the duration of the checkout. When a checkout comppletes, the
#     inventory decreases as well. When the checkout does not complete (in a set time),
#     the availability is restored.
#
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
  validates :inventory, numericality: { min: 0 }, presence: true
  validates :availability, numericality: { min: 0 }, presence: true

  # == Hooks =======================================================================
  before_create :add_availability
  before_update :update_availability

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
  private

  def add_availability
    self.availability = inventory
  end

  def update_availability
    # TODO: handle case when availability would fall under zero
    difference = inventory - inventory_was
    self.availability += difference
  end
end
