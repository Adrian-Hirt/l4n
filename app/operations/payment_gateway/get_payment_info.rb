module Operations::PaymentGateway
  class GetPaymentInfo < RailsOps::Operation
    without_authorization

    attr_accessor :result

    def perform
      fail 'No order_id given' if osparams.order_id.blank?

      # Decrypt the order id
      crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31])
      encrypted_id = Base64.urlsafe_decode64(osparams.order_id)
      decrypted_id = crypt.decrypt_and_verify(encrypted_id)

      # Get order
      order = ::Order.find(decrypted_id)

      # TODO: handle these fail states gracefully
      # Verify that the order is still active and in the correct state
      fail 'Order has wrong status' unless order.created? || order.payment_pending?

      if order.created?
        fail 'Order expired' if order.cleanup_timestamp + ::Order::TIMEOUT < Time.zone.now
      elsif order.cleanup_timestamp + ::Order::TIMEOUT_PAYMENT_PENDING < Time.zone.now
        fail 'Order expired'
      end

      # Check that no product_variant has been deleted while loading the payment gateway
      fail 'An product variant has been deleted' if order.order_items.any? { |order_item| order_item.product_variant.nil? }

      fail 'No address present' unless order.address_present?

      # Set order as payment pending
      begin
        order.payment_pending!
      rescue ActiveRecord::RecordInvalid
        throw 'Could not set the order as payment pending'
      end

      @result = {}
      @result[:items] = [] # TODO
      @result[:order_id] = osparams.order_id
      # minus 1 minute to have some "padding" between redirect and cleanup
      @result[:valid_until] = order.cleanup_timestamp + ::Order::TIMEOUT_PAYMENT_PENDING - 1.minute
      total = Money.zero

      order.order_items.each do |order_item|
        total += order_item.total
      end

      @result[:total] = total
    end
  end
end
