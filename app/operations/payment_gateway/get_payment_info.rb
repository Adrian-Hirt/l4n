module Operations::PaymentGateway
  class GetPaymentInfo < RailsOps::Operation
    without_authorization

    attr_accessor :result

    def perform
      fail InvalidOrder, 'No order_id given' if osparams.order_id.blank?

      # Decrypt the order id
      secret = ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base
      crypt = ActiveSupport::MessageEncryptor.new(secret[0..31])
      encrypted_id = Base64.urlsafe_decode64(osparams.order_id)
      decrypted_id = crypt.decrypt_and_verify(encrypted_id)

      # Get order
      order = ::Order.find(decrypted_id)

      # Verify that the order is still active and in the correct state
      fail InvalidOrder, 'Order has wrong status' unless order.created? || order.payment_pending?

      if order.created?
        fail InvalidOrder, 'Order expired' if order.cleanup_timestamp + ::Order::TIMEOUT < Time.zone.now
      elsif order.cleanup_timestamp + ::Order::TIMEOUT_PAYMENT_PENDING < Time.zone.now
        fail InvalidOrder, 'Order expired'
      end

      # Check that no product_variant has been deleted while loading the payment gateway
      fail InvalidOrder, 'An product variant has been deleted' if order.order_items.any? { |order_item| order_item.product_variant.nil? }

      fail InvalidOrder, 'No address present' unless order.address_present?

      # Set order as payment pending
      begin
        order.payment_pending!
      rescue ActiveRecord::RecordInvalid
        fail InvalidOrder, 'Could not set the order as payment pending'
      end

      @result = {}
      @result[:order_id] = osparams.order_id
      @result[:real_order_id] = decrypted_id

      items = []

      order.order_items.each do |order_item|
        items << {
          product:  order_item.product_name,
          quantity: order_item.quantity,
          price:    order_item.price_cents
        }
      end

      @result[:items] = items

      # minus 1 minute to have some "padding" between redirect and cleanup
      @result[:valid_until] = order.cleanup_timestamp + ::Order::TIMEOUT_PAYMENT_PENDING - 1.minute
      total = Money.zero

      order.order_items.each do |order_item|
        total += order_item.total
      end

      order.promotion_code_mappings.each do |mapping|
        total -= mapping.applied_reduction
      end

      @result[:total] = total
    end
  end

  class InvalidOrder < StandardError; end
end
