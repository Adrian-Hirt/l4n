class FooterLogo < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  has_one_attached :file do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 20]
    attachable.variant :medium, resize_to_limit: [200, 40]
  end

  # == Validations =================================================================
  validates :sort, numericality: { min: 0 }, presence: true
  validates_boolean :visible
  validates :file, attached: true, content_type: ['image/png', 'image/jpeg']

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
