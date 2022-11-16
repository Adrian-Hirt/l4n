class StartpageBanner < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [150, 150]
  end

  # == Validations =================================================================
  validates_boolean :visible
  validates :name, presence: true, length: { maximum: 255 }
  validates :height, numericality: { in: 150..1000 }

  # == Hooks =======================================================================
  before_save :set_others_to_not_visible

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
  private

  def set_others_to_not_visible
    return unless visible?

    # rubocop:disable Rails/SkipsModelValidations
    self.class.where('id <> ? AND visible = true', id).update_all("visible = 'false'")
    # rubocop:enable Rails/SkipsModelValidations
  end
end
