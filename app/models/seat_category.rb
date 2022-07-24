class SeatCategory < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================
  PREDEFINED_SEATCATEGORY_COLORS = {
    'green'       => { title: _('Colors|Green'), value: '#008000' },
    'yellow'      => { title: _('Colors|Yellow'), value: '#ffff00' },
    'orange'      => { title: _('Colors|Orange'), value: '#ff8000' },
    'blue'        => { title: _('Colors|Blue'), value: '#0000ff' },
    'pink'        => { title: _('Colors|Pink'), value: '#ffb6c1' },
    'light_blue'  => { title: _('Colors|Light blue'), value: '#00ffff' },
    'light_green' => { title: _('Colors|Light green'), value: '#00ff00' },
    'olive'       => { title: _('Colors|Olive'), value: '#808000' }
  }.freeze

  # == Associations ================================================================
  belongs_to :lan_party

  # == Validations =================================================================
  validates :name, presence: true, length: { maximum: 255 }
  validates :color, presence: true, inclusion: PREDEFINED_SEATCATEGORY_COLORS.keys

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def color_for_view
    PREDEFINED_SEATCATEGORY_COLORS[color][:value]
  end

  # == Private Methods =============================================================
end
