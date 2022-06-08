class MenuLinkItem < MenuItem
  # == Attributes ==================================================================
  attr_writer :page_attr

  def page_attr
    page_id || static_page_name
  end

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :parent, class_name: 'MenuDropdownItem', optional: true
  belongs_to :page, optional: true

  # == Validations =================================================================
  validates :static_page_name, length: { maximum: 255 }
  validate :static_page_name_or_id_set

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def linked_page_name
    if page
      page.title
    else
      PREDEFINED_PAGES.dig(static_page_name, :title)
    end
  end

  def linked_page_url
    if page
      page.url
    else
      static_page_name
    end
  end

  def visible?
    if page.present?
      FeatureFlag.enabled?(:pages) && page.published?
    else
      flag = PREDEFINED_PAGES.dig(static_page_name, :feature_flag)
      FeatureFlag.enabled?(flag)
    end
  end

  alias visible visible?

  # == Private Methods =============================================================
  private

  def static_page_name_or_id_set
    if static_page_name.blank? && page_id.blank?
      errors.add(:page_attr, I18n.t('errors.messages.empty'))
    elsif static_page_name.present? && page_id.present?
      errors.add(:page_attr, _('MenuLinkItem|Can only set static page name or page id'))
    end
  end
end
