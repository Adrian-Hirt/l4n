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

      # Verify that the order is still active and in the correct state
      fail 'Order has wrong status' unless order.created?

      fail 'Order expired' if order.cleanup_timestamp + ::Order::TIMEOUT_IN_PAYMENT < Time.zone.now

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
