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
  validates :external_link, length: { maximum: 255 }
  validate :only_valid_combination

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def link_destination
    if page
      page.title
    elsif static_page_name.present?
      PREDEFINED_PAGES.dig(static_page_name, :title)
    else
      external_link
    end
  end

  def linked_page_url
    if page
      page.url
    elsif static_page_name.present?
      static_page_name
    else
      external_link
    end
  end

  def to_external?
    external_link.present?
  end

  def visible?
    if page.present?
      FeatureFlag.enabled?(:pages) && page.published?
    else
      flag = PREDEFINED_PAGES.dig(static_page_name, :feature_flag)
      return true if flag.nil?

      FeatureFlag.enabled?(flag)
    end
  end

  alias visible visible?

  # == Private Methods =============================================================
  private

  def only_valid_combination
    # We only allow to have either the `static_page_name`, the `page_id`
    # or the `external_link` to be set, but at least one needs to be set.
    if static_page_name.blank? && page_id.blank? && external_link.blank?
      errors.add(:page_attr, _('MenuLinkItem|Please either select a page or set an external link'))
      errors.add(:external_link, _('MenuLinkItem|Please either select a page or set an external link'))
      return
    end

    errors.add(:page_attr, _('MenuLinkItem|Can only set static page name or page id')) if static_page_name.present? && page_id.present?

    return unless page_attr.present? && external_link.present?

    errors.add(:page_attr, _('MenuLinkItem|Can only select a page or enter an external link but not both'))
    errors.add(:external_link, _('MenuLinkItem|Can only select a page or enter an external link but not both'))
  end
end
