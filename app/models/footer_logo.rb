class FooterLogo < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  has_one_attached :file do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :medium, resize_to_limit: [200, 200]
  end

  # == Validations =================================================================
  validates :sort, numericality: { min: 0 }, presence: true
  validates_boolean :visible
  validates :file, attached: true

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
