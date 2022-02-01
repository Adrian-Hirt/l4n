# {Product} stores a product, with an associated availability and inventory.
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
class Product < ApplicationRecord
  include ::ProductBehaviours

  # == Attributes ==================================================================
  register_behaviour :event_ticket, ::Operations::Behaviours::EventTicket

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :product_variants, dependent: :destroy
  accepts_nested_attributes_for :product_variants, allow_destroy: true

  # == Validations =================================================================
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates :on_sale, inclusion: [true, false]
  validates :inventory, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :availability, numericality: { greater_than_or_equal_to: 0 }, presence: true

  # == Hooks =======================================================================
  before_create :add_availability
  before_update :update_availability

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def starting_price
    product_variants.map(&:price).min.presence || Money.zero
  end

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
