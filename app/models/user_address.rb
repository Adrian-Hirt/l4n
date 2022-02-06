class UserAddress < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :user

  # == Validations =================================================================
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }
  validates :street, presence: true, length: { maximum: 255 }
  validates :zip_code, presence: true, length: { maximum: 255 }
  validates :city, presence: true, length: { maximum: 255 }

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
