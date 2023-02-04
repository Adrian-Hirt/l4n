class LanParty < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :seat_categories, dependent: :destroy
  has_one :seat_map, dependent: :destroy
  has_many :tickets, dependent: :restrict_with_exception
  has_many :tournaments, dependent: :nullify
  has_one :timetable, dependent: :destroy
  has_many :menu_items, dependent: :destroy

  # == Validations =================================================================
  validates :name, presence: true, length: { maximum: 255 }
  validates :sort, presence: true
  validates_boolean :active
  validates_boolean :sidebar_active
  validates_boolean :timetable_enabled
  validates_boolean :seatmap_enabled
  validates :event_start, presence: true
  validates :event_end, presence: true, comparison: { greater_than: :event_start }

  # == Hooks =======================================================================
  before_destroy :check_if_deletable, prepend: true

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  # For now: not deletable if any tickets are created for the lan_party
  def deleteable?
    tickets.none?
  end

  # == Private Methods =============================================================
  private

  def check_if_deletable
    throw :abort unless deleteable?
  end
end
