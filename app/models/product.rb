class Product < ApplicationRecord
  ################################### Attributes ###################################

  ################################### Constants ####################################

  ################################### Associations #################################
  has_many :product_variants, dependent: :destroy
  accepts_nested_attributes_for :product_variants, allow_destroy: true

  ################################### Validations ##################################
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates :on_sale, inclusion: [true, false]

  ################################### Hooks #######################################

  ################################### Scopes #######################################

  ################################### Class Methods ################################

  ################################### Instance Methods #############################

  ################################### Private Methods ##############################
end
