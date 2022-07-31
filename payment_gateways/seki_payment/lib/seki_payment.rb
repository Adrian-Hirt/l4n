require 'seki_payment/version'
require 'seki_payment/engine'

module SekiPayment
  def self.payment_path(*args)
    SekiPayment::Engine.routes.url_helpers.start_payment_path(*args)
  end

  def self.name
    'Seki payment gateway'
  end
end
