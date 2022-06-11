class Order < ApplicationRecord
  # == Attributes ==================================================================
  enum status: {
    created:         'created',
    payment_pending: 'payment_pending',
    paid:            'paid'
  }

  # == Constants ===================================================================
  TIMEOUT = 15.minutes
  TIMEOUT_PAYMENT_PENDING = 45.minutes
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

  # == Hooks =======================================================================

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
    "#{_('Order')} ##{id}"
  end

  def total
    result = Money.zero
    result += order_items.sum(&:total)
    result -= promotion_code_mappings.sum(&:applied_reduction)
    result
  end

  # == Private Methods =============================================================
end
