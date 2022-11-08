class MenuItem < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================
  PREDEFINED_PAGES = {
    'news'          => { title: _('News'), feature_flag: :news_posts },
    'events'        => { title: _('Events'), feature_flag: :events },
    'shop'          => { title: _('Shop'), feature_flag: :shop },
    'lan/seatmap'   => { title: _('LanParty|SeatMap'), feature_flag: :lan_party },
    'lan/timetable' => { title: _('LanParty|Timetable'), feature_flag: :lan_party },
    'tournaments'   => { title: _('Tournaments'), feature_flag: :tournaments },
    'users'         => { title: _('Users List') }
  }.freeze

  TYPES = %w[MenuLinkItem MenuDropdownItem].freeze

  # == Associations ================================================================

  # == Validations =================================================================
  validates :sort, numericality: { min: 0 }, presence: true
  validates_boolean :visible
  validates :title, presence: true, length: { maximum: 255 }
  validates :type, inclusion: TYPES

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
