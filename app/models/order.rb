class Order < ApplicationRecord
  # == Attributes ==================================================================
  enum status: {
    created:                 'created',
    payment_pending:         'payment_pending',
    delayed_payment_pending: 'delayed_payment_pending',
    processing:              'processing',
    completed:               'completed'
  }

  translate_enums

  attr_accessor :skip_address_validation

  # == Constants ===================================================================
  TIMEOUT = 15.minutes
  TIMEOUT_PAYMENT_PENDING = 45.minutes
  TIMEOUT_DELAYED_PAYMENT_PENDING = 4.days
  SHIPPING_ADDRESS_FIELDS = %i[billing_address_first_name billing_address_last_name billing_address_street billing_address_zip_code billing_address_city].freeze

  # == Associations ================================================================
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :tickets, dependent: :nullify
  has_many :promotion_code_mappings, dependent: :destroy
  has_many :promotion_codes, through: :promotion_code_mappings

  # == Validations =================================================================
  SHIPPING_ADDRESS_FIELDS.each do |shipping_address_field|
    validates shipping_address_field, length: { maximum: 255 }
    validates shipping_address_field, presence: true, if: :requires_address?, unless: :skip_address_validation
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
    secret = ENV['SECRET_KEY_BASE'] || Rails.application.credentials.secret_key_base
    crypt = ActiveSupport::MessageEncryptor.new(secret[0..31])
    encrypted_id = crypt.encrypt_and_sign(id)
    Base64.urlsafe_encode64(encrypted_id)
  end

  def address_present?
    SHIPPING_ADDRESS_FIELDS.all? { |shipping_address_field| public_send(shipping_address_field).present? }
  end

  def any_address_field_present?
    SHIPPING_ADDRESS_FIELDS.any? { |shipping_address_field| public_send(shipping_address_field).present? }
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
    # A completed or processing order can never expire
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

  def delayed_payment_can_be_submitted?
    # Check correct status
    return false unless delayed_payment_pending?

    # Check order not expired
    return false if expired?

    # Check that no product_variant has been deleted while loading the payment gateway
    return false if order_items.any? { |order_item| order_item.product_variant.nil? }

    # Check that no product is not not on sale anymore
    return false if order_items.any? { |order_item| !order_item.product_variant.product.on_sale? }

    # Otherwise, all good
    true
  end

  def paid!
    # If any product behaviours on the order require manual
    # processing, we set the status to `processing`, otherwise
    # we set the status to `completed`
    if order_items.any? { |order_item| order_item.product.enabled_product_behaviour_classes.any?(&:requires_manual_processing?) }
      processing!
    else
      # Set status
      self.status = Order.statuses[:completed]

      # Remove the address, just to be on the safe side.
      remove_address

      # And finally save the order
      save!
    end
  end

  def paid?
    completed? || processing?
  end

  def requires_address?
    order_items.any? { |order_item| order_item.product.enabled_product_behaviour_classes.any?(&:requires_address?) }
  end

  def remove_address
    # Does not do anything unless the status is `completed`
    fail 'Wrong status' unless completed?

    SHIPPING_ADDRESS_FIELDS.each do |field|
      public_send("#{field}=", nil)
    end
  end

  def deleteable?
    # An order which is created, completed or waiting for the delayed payment is
    # always deleteable.
    return true if created? || delayed_payment_pending? || completed?

    # Otherwise, a payment pending order is only
    # deleteable if it's expired
    return expired? if payment_pending?

    # Return false if none of the previous conditions was true
    false
  end

  # == Private Methods =============================================================
  private

  def check_if_deletable
    return if deleteable?

    errors.add(:base, _('Order|Cannot delete order with that status'))
    throw :abort
  end
end
