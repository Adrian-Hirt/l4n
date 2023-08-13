require 'paypal_payment/version'
require 'paypal_payment/engine'

module PaypalPayment
  def self.payment_path(*)
    PaypalPayment::Engine.routes.url_helpers.start_payment_path(*)
  end

  def self.name
    _('PaypalPaymentGateway')
  end

  def self.payment_button_text
    _('PaypalPaymentGateway|Pay')
  end
end
