class Ticket < ApplicationRecord
  include Encryptable

  # == Attributes ==================================================================
  enum :status, {
    created:    'created',
    assigned:   'assigned',
    checked_in: 'checked_in'
  }

  translate_enums

  encryptable_attribute :qr_id, %i[id assignee_id]

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :lan_party
  belongs_to :seat_category
  belongs_to :order, optional: true
  belongs_to :assignee, class_name: 'User', optional: true

  has_one :seat, dependent: :nullify

  # == Validations =================================================================
  validates :status, presence: true, inclusion: statuses.keys

  # == Hooks =======================================================================

  # == Scopes ======================================================================
  scope :checked_in, -> { where(status: 'checked_in') }

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
