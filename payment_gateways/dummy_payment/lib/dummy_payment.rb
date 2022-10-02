require 'dummy_payment/version'
require 'dummy_payment/engine'

module DummyPayment
  def self.payment_path(*args)
    DummyPayment::Engine.routes.url_helpers.start_payment_path(*args)
  end

  def self.name
    _('DummyPaymentGateway')
  end
end
