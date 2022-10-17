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
  validates :images, size: { less_than: 5.megabytes, message: format(_('File is too large, max. allowed %{size}'), size: '5MB') }, content_type: %r{\Aimage/.*\z}
  validates :sort, numericality: { min: 0 }, presence: true

  # == Hooks =======================================================================
  before_create :add_availability

  # == Scopes ======================================================================

  # == Class Methods ===============================================================
  def self.grouped_by_lan
    grouped = SeatCategory.all.group_by(&:lan_party_id)
    grouped.each do |k, v|
      grouped[k] = v.map do |category|
        category.products.map { |product| { id: product.id, name: product.name } }
      end.compact_blank.flatten
    end

    grouped
  end

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
