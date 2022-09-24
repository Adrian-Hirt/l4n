class ScannerUser < ApplicationRecord
  # == Attributes ==================================================================
  devise :database_authenticatable, authentication_keys: %i[name]

  # == Constants ===================================================================

  # == Associations ================================================================

  # == Validations =================================================================
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates :password, presence: true, length: { minimum: 6, maximum: 72 }, if: -> { password.present? || new_record? }

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
