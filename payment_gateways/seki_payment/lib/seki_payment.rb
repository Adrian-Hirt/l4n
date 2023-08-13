require 'seki_payment/version'
require 'seki_payment/engine'

module SekiPayment
  def self.payment_path(*)
    SekiPayment::Engine.routes.url_helpers.start_payment_path(*)
  end

  def self.name
    _('SekiPaymentGateway')
  end

  def self.payment_button_text
    _('SekiPaymentGateway|Pay')
  end
end
