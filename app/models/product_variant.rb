class ProductVariant < ApplicationRecord
  ################################### Attributes ###################################
  monetize :price_cents

  ################################### Constants ####################################

  ################################### Associations #################################
  belongs_to :product
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :nullify

  ################################### Validations ##################################
  validates :name, presence: true, length: { maximum: 255 }
  validates :inventory, numericality: { min: 0 }, presence: true

  ################################### Hooks #######################################

  ################################### Scopes #######################################

  ################################### Class Methods ################################

  ################################### Instance Methods #############################

  ################################### Private Methods ##############################
end
