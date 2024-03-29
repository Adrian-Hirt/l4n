class MenuDropdownItem < MenuItem
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :children, class_name: 'MenuLinkItem', foreign_key: 'parent_id', dependent: :destroy, inverse_of: :parent

  # == Validations =================================================================
  validates :parent_id, absence: true

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
