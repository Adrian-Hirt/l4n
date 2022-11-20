class ContentPage < Page
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :menu_items, dependent: :destroy

  # == Validations =================================================================
  validates :title, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates_boolean :published
  validates_boolean :use_sidebar

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def readable?
    published? && FeatureFlag.enabled?(:dynamic_routing_entries)
  end

  # == Private Methods =============================================================
end
