class MenuLinkItem < MenuItem
  # == Attributes ==================================================================
  attr_writer :page_attr

  def page_attr
    page_id || static_page_name
  end

  # == Constants ===================================================================
  PREDEFINED_PAGES = {
    'news'          => { title: _('News'), feature_flag: :news_posts },
    'events'        => { title: _('Events'), feature_flag: :events },
    'shop'          => { title: _('Shop'), feature_flag: :shop },
    'tournaments'   => { title: _('Tournaments'), feature_flag: :tournaments },
    'users'         => { title: _('Users List') }
  }.freeze

  PREDEFINED_LAN_PAGES = {
    'seatmap'   => { title: _('LanParty|SeatMap'), feature_flag: :lan_party },
    'timetable' => { title: _('LanParty|Timetable'), feature_flag: :lan_party },
    'tickets'   => { title: _('LanParty|Tickets'), feature_flag: :lan_party }
  }

  # == Associations ================================================================
  belongs_to :parent, class_name: 'MenuDropdownItem', optional: true
  belongs_to :page, optional: true
  belongs_to :lan_party, optional: true

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
    elsif lan_party_id.present?
      "#{lan_party.name} - #{PREDEFINED_LAN_PAGES.dig(static_page_name, :title)}"
    elsif static_page_name.present?
      PREDEFINED_PAGES.dig(static_page_name, :title)
    else
      external_link
    end
  end

  def linked_page_url
    if page
      page.url
    elsif lan_party_id.present?
      "lan/#{lan_party_id}/#{static_page_name}"
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

    # If the lan_party_id is set, the static_page_name needs to be set
    # and needs to be a value from the PREDEFINED_LAN_PAGES enum
    if lan_party_id.present?
      # Page_id and external_link may not be present
      errors.add(:lan_party_id, _('MenuLinkItem|may not be set')) if page_id.present? || external_link.present?

      # The given page must be included in the PREDEFINED_LAN_PAGES enum
      errors.add(:page_attr, _('MenuLinkItem|Must be a lan party page')) unless PREDEFINED_LAN_PAGES.keys.include?(static_page_name)
    end

    # Lan party id must be set if the chosen page is a lan-party related page
    errors.add(:lan_party_id, _('MenuLinkItem|must be set')) if PREDEFINED_LAN_PAGES.keys.include?(static_page_name) && lan_party_id.blank?

    return unless page_attr.present? && external_link.present?

    errors.add(:page_attr, _('MenuLinkItem|Can only select a page or enter an external link but not both'))
    errors.add(:external_link, _('MenuLinkItem|Can only select a page or enter an external link but not both'))
  end
end
