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
# @!attribute total_inventory
#   @return [Integer] Total number of products that are overall for sale. This is only
#     increased or decreased when the inventory is manually changed (not when an item is
#     sold). This is helpful for bookkeeping (e.g. to know how many have been put into the
#     shop totally).
#
class Product < ApplicationRecord
  include ::ProductBehaviours

  # == Attributes ==================================================================
  register_behaviour :ticket, ::Operations::Behaviours::Ticket
  register_behaviour :ticket_upgrade, ::Operations::Behaviours::TicketUpgrade

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :product_variants, dependent: :destroy
  accepts_nested_attributes_for :product_variants, allow_destroy: true

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_and_pad: [100, 100, { background: [255, 255, 255] }]
    attachable.variant :medium, resize_and_pad: [300, 300, { background: [255, 255, 255] }]
  end

  # For product behaviours
  belongs_to :seat_category, optional: true
  belongs_to :to_product, optional: true, class_name: 'Product'
  belongs_to :from_product, optional: true, class_name: 'Product'

  belongs_to :product_category

  has_many :promotion_products, dependent: :destroy
  has_many :promotions, through: :promotion_products

  # == Validations =================================================================
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates_boolean :on_sale
  validates :inventory, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :availability, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :total_inventory, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :images, size: { less_than: 5.megabytes, message: _('File is too large, max. allowed %{size}') % { size: '5MB' } }, content_type: %r{\Aimage/.*\z}
  validates :sort, numericality: { min: 0 }, presence: true
  validates :seat_category, uniqueness: true, if: :seat_category

  # == Hooks =======================================================================
  before_create :add_availability_and_total_inventory
  before_destroy :check_deleteable?

  # == Scopes ======================================================================

  # == Class Methods ===============================================================
  def self.grouped_by_lan
    grouped = SeatCategory.all.group_by(&:lan_party_id)
    grouped.each do |k, v|
      grouped[k] = v.map do |category|
        { id: category.product&.id, name: category.product&.name }
      end.compact_blank.flatten
    end

    grouped
  end

  # == Instance Methods ============================================================
  def starting_price
    product_variants.map(&:price).min.presence || Money.zero
  end

  def deleteable?
    Product.where('to_product_id = ? OR from_product_id = ?', id, id).none?
  end

  # == Private Methods =============================================================
  private

  def add_availability_and_total_inventory
    self.availability = inventory
    self.total_inventory = inventory
  end

  def check_deleteable?
    return if deleteable?

    throw :abort
  end
end
