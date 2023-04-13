class Promotion < ApplicationRecord
  # == Attributes ==================================================================
  enum code_type: {
    free_item:   'free_item',
    fixed_value: 'fixed_value'
  }

  monetize :reduction_cents, allow_nil: true

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :promotion_products, dependent: :destroy
  has_many :products, through: :promotion_products
  has_many :promotion_codes, dependent: :destroy

  # == Validations =================================================================
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates_boolean :active
  validates :code_type, presence: true, inclusion: code_types.keys
  validates :code_prefix, length: { maximum: 20 }
  validates :reduction, presence: true, if: -> { fixed_value? }
  validates :reduction, absence: true, if: -> { free_item? }

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def deleteable?
    promotion_codes.none?(&:used?)
  end

  # == Private Methods =============================================================
end
