module Operations::PaymentGateway
  class MarkForDelayedPayment < RailsOps::Operation
    without_authorization

    schema3 do
      str! :order_id
      str! :gateway_name
    end

    def perform
      fail 'No order_id given' if osparams.order_id.blank?

      # Decrypt the order id
      secret = ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base
      crypt = ActiveSupport::MessageEncryptor.new(secret[0..31])
      encrypted_id = Base64.urlsafe_decode64(osparams.order_id)
      decrypted_id = crypt.decrypt_and_verify(encrypted_id)

      # Get order
      order = ::Order.find_by(id: decrypted_id)

      fail 'Order not found' if order.nil?

      run_sub Operations::Shop::Order::ProcessMarkedForDelayedPayment, order: order, gateway_name: osparams.gateway_name
    end
  end
end
