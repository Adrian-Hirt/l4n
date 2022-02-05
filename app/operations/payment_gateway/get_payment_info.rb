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

      fail 'Order expired' if order.cleanup_timestamp + ::Order::TIMEOUT < Time.zone.now

      # Check that no product_variant has been deleted while loading the payment gateway
      fail 'An product variant has been deleted' if order.order_items.any? { |order_item| order_item.product_variant.nil? }

      # Set order as payment pending
      order.payment_pending!

      @result = {}
      @result[:items] = [] # TODO
      @result[:order_id] = osparams.order_id
      total = Money.zero

      order.order_items.each do |order_item|
        total += order_item.total
      end

      @result[:total] = total
    end
  end
end
