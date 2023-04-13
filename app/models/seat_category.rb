class SeatCategory < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================
  PREDEFINED_SEATCATEGORY_COLORS = {
    'green'       => { title: _('Colors|Green'), value: '#008000', font_color: 'white' },
    'yellow'      => { title: _('Colors|Yellow'), value: '#ffff00', font_color: 'black' },
    'orange'      => { title: _('Colors|Orange'), value: '#ff8000', font_color: 'black' },
    'blue'        => { title: _('Colors|Blue'), value: '#0000ff', font_color: 'white' },
    'pink'        => { title: _('Colors|Pink'), value: '#ffb6c1', font_color: 'black' },
    'light_blue'  => { title: _('Colors|Light blue'), value: '#00ffff', font_color: 'black' },
    'light_green' => { title: _('Colors|Light green'), value: '#00ff00', font_color: 'black' },
    'olive'       => { title: _('Colors|Olive'), value: '#808000', font_color: 'white' }
  }.freeze

  # == Associations ================================================================
  belongs_to :lan_party
  has_one :product, dependent: :restrict_with_exception
  has_many :seats, dependent: :restrict_with_exception
  has_many :tickets, dependent: :restrict_with_exception

  # == Validations =================================================================
  validates :name, presence: true, length: { maximum: 255 }
  validates :color, presence: true, inclusion: PREDEFINED_SEATCATEGORY_COLORS.keys
  validates_boolean :relevant_for_counter

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================
  def self.grouped_by_lan
    grouped = SeatCategory.all.group_by(&:lan_party_id)
    grouped.each do |k, v|
      grouped[k] = v.map { |category| { id: category.id, name: category.name } }
    end

    grouped
  end

  # == Instance Methods ============================================================
  def color_for_view
    PREDEFINED_SEATCATEGORY_COLORS[color][:value]
  end

  def font_color_for_view
    PREDEFINED_SEATCATEGORY_COLORS[color][:font_color]
  end

  def deleteable?
    product.nil? && seats.none? && tickets.none?
  end

  # == Private Methods =============================================================
end
