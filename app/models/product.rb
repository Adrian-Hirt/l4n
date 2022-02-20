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
  register_behaviour :dummy, ::Operations::Behaviours::DummyBehaviour
  register_behaviour :ticket, ::Operations::Behaviours::Ticket

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :product_variants, dependent: :destroy
  accepts_nested_attributes_for :product_variants, allow_destroy: true

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_and_pad: [100, 100, { background: [255, 255, 255] }]
    attachable.variant :medium, resize_and_pad: [300, 300, { background: [255, 255, 255] }]
  end

  belongs_to :seat_category, optional: true

  # == Validations =================================================================
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates :on_sale, inclusion: [true, false]
  validates :inventory, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :availability, numericality: { greater_than_or_equal_to: 0 }, presence: true

  validates :seat_category, presence: true, if: -> { enabled_product_behaviours.include? 'ticket' }

  # == Hooks =======================================================================
  before_create :add_availability

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
end
