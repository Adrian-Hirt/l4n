require 'dummy_payment/version'
require 'dummy_payment/engine'

module DummyPayment
  def self.payment_path(*)
    DummyPayment::Engine.routes.url_helpers.start_payment_path(*)
  end

  def self.name
    _('DummyPaymentGateway')
  end

  def self.payment_button_text
    _('DummyPaymentGateway|Pay')
  end
end
