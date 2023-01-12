class Order < ApplicationRecord
  # == Attributes ==================================================================
  enum status: {
    created:                 'created',
    payment_pending:         'payment_pending',
    delayed_payment_pending: 'delayed_payment_pending',
    paid:                    'paid'
  }

  translate_enums

  # == Constants ===================================================================
  TIMEOUT = 15.minutes
  TIMEOUT_PAYMENT_PENDING = 45.minutes
  TIMEOUT_DELAYED_PAYMENT_PENDING = 4.days
  SHIPPING_ADDRESS_FIELDS = %i[billing_address_first_name billing_address_last_name billing_address_street billing_address_zip_code billing_address_city].freeze

  # == Associations ================================================================
  belongs_to :user
  has_many :order_items, dependent: :destroy

  has_many :promotion_code_mappings, dependent: :destroy
  has_many :promotion_codes, through: :promotion_code_mappings

  # == Validations =================================================================
  SHIPPING_ADDRESS_FIELDS.each do |shipping_address_field|
    validates shipping_address_field, length: { maximum: 255 }
    validates shipping_address_field, presence: true, unless: :created?
  end

  validates :payment_gateway_name, length: { maximum: 255 }
  validates :payment_gateway_payment_id, length: { maximum: 255 }
  validates :status, presence: true, inclusion: statuses.keys

  # == Hooks =======================================================================
  before_destroy :check_if_deletable, prepend: true

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def encrypted_base64_id
    secret = ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base
    crypt = ActiveSupport::MessageEncryptor.new(secret[0..31])
    encrypted_id = crypt.encrypt_and_sign(id)
    Base64.urlsafe_encode64(encrypted_id)
  end

  def address_present?
    SHIPPING_ADDRESS_FIELDS.all? { |shipping_address_field| public_send(shipping_address_field).present? }
  end

  def formatted_id
    "#{_('Order')} ##{uuid}"
  end

  def total
    result = Money.zero
    result += order_items.sum(&:total)
    result -= promotion_code_mappings.sum(&:applied_reduction)
    result
  end

  def expired?
    # A paid order can never expire
    return false if paid?

    if created?
      cleanup_timestamp + ::Order::TIMEOUT < Time.zone.now
    elsif payment_pending?
      cleanup_timestamp + ::Order::TIMEOUT_PAYMENT_PENDING < Time.zone.now
    elsif delayed_payment_pending?
      cleanup_timestamp + ::Order::TIMEOUT_DELAYED_PAYMENT_PENDING < Time.zone.now
    else
      fail 'Unknown status'
    end
  end

  # == Private Methods =============================================================
  private

  def check_if_deletable
    return if created? || payment_pending? || delayed_payment_pending?

    errors.add(:base, _('Order|Cannot delete order with that status'))
    throw :abort
  end
end
