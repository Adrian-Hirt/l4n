class LanParty < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :seat_categories, dependent: :destroy
  has_one :seat_map, dependent: :destroy
  has_many :tickets, dependent: :restrict_with_exception
  has_many :tournaments, dependent: :nullify
  has_one :timetable, dependent: :destroy

  # == Validations =================================================================
  validates :name, presence: true, length: { maximum: 255 }
  validates_boolean :active
  validates :event_start, presence: true
  validates :event_end, presence: true, comparison: { greater_than: :event_start }

  # == Hooks =======================================================================
  before_save :set_others_to_inactive
  before_destroy :check_if_deletable, prepend: true

  # == Scopes ======================================================================

  # == Class Methods ===============================================================
  def self.active
    LanParty.find_by(active: true)
  end

  # == Instance Methods ============================================================
  # For now: not deletable if any tickets are created for the lan_party
  def deleteable?
    tickets.none?
  end

  # == Private Methods =============================================================
  private

  def set_others_to_inactive
    return unless active?

    # rubocop:disable Rails/SkipsModelValidations
    self.class.where('id <> ? AND active = true', id).update_all("active = 'false'")
    # rubocop:enable Rails/SkipsModelValidations
  end

  def check_if_deletable
    throw :abort unless deleteable?
  end
end
