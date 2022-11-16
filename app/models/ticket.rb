class Ticket < ApplicationRecord
  include Encryptable

  # == Attributes ==================================================================
  enum status: {
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
  validate :restrict_seat_category_if_no_order

  # == Hooks =======================================================================

  # == Scopes ======================================================================
  scope :checked_in, -> { where(status: 'checked_in') }

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================

  # == Private Methods =============================================================
  private

  def restrict_seat_category_if_no_order
    # If we have an order we can directly return
    return if order.present?

    # Return early if we have no seat_category set
    return if seat_category.nil?

    # Otherwise we need to check that the seat_category has no product set.
    # If yes, we add an error
    return if seat_category.product.nil?

    errors.add(:seat_category, _('Ticket|Seat category must not be assigned to a product when manually creating a ticket'))
  end
end
