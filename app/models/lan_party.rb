class LanParty < ApplicationRecord
  # == Attributes ==================================================================

  # == Constants ===================================================================

  # == Associations ================================================================
  has_many :seat_categories, dependent: :destroy
  has_one :seat_map, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :tournaments, dependent: :nullify

  # == Validations =================================================================
  validates :name, presence: true, length: { maximum: 255 }
  validates_boolean :active

  # == Hooks =======================================================================
  before_save :set_others_to_inactive

  # == Scopes ======================================================================

  # == Class Methods ===============================================================
  def self.active
    LanParty.find_by(active: true)
  end

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
  private

  def set_others_to_inactive
    return unless active?

    # rubocop:disable Rails/SkipsModelValidations
    self.class.where('id <> ? AND active = true', id).update_all("active = 'false'")
    # rubocop:enable Rails/SkipsModelValidations
  end
end
