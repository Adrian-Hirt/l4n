class MenuItem < ApplicationRecord
  ################################### Attributes ###################################
  extend Mobility
  translates :title

  ################################### Constants ####################################
  PREDEFINED_PAGES = {
    'news'        => { title: _('News'), feature_flag: :news_posts },
    'events'      => { title: _('Events'), feature_flag: :events },
    'shop'        => { title: _('Shop'), feature_flag: :shop },
    'lan/seatmap' => { title: _('LanParty|SeatMap'), feature_flag: :lan_party }
  }.freeze

  TYPES = %w[MenuLinkItem MenuDropdownItem].freeze

  ################################### Associations #################################

  ################################### Validations ##################################
  validates :sort, numericality: { min: 0 }, presence: true
  validates :visible, inclusion: [true, false]
  validates_translated :title, presence: true, length: { maximum: 255 }
  validates :type, inclusion: TYPES

  ################################### Hooks #######################################

  ################################### Scopes #######################################

  ################################### Class Methods ################################

  ################################### Instance Methods #############################

  ################################### Private Methods ##############################
end
