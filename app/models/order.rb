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

  # == Validations =================================================================
  SHIPPING_ADDRESS_FIELDS.each do |shipping_address_field|
    validates shipping_address_field, length: { maximum: 255 }
    validates shipping_address_field, presence: true, unless: :created?
  end

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def encrypted_base64_id
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31])
    encrypted_id = crypt.encrypt_and_sign(id)
    Base64.urlsafe_encode64(encrypted_id)
  end

  def address_present?
    SHIPPING_ADDRESS_FIELDS.all? { |shipping_address_field| public_send(shipping_address_field).present? }
  end

  # == Private Methods =============================================================
end
