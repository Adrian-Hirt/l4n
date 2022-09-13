class Ticket < ApplicationRecord
  # == Attributes ==================================================================
  enum status: {
    created:    'created',
    assigned:   'assigned',
    checked_in: 'checked_in'
  }

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :lan_party
  belongs_to :seat_category
  belongs_to :order
  belongs_to :assignee, class_name: 'User', optional: true

  has_one :seat, dependent: :nullify

  # == Validations =================================================================
  validates :status, presence: true, inclusion: statuses.keys

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
end
