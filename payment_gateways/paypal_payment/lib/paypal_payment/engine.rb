module PaypalPayment
  class Engine < ::Rails::Engine
    isolate_namespace PaypalPayment

    initializer 'seki_payment.configuration' do |app|
      app.routes.append do
        mount PaypalPayment::Engine => '/paymentgateway/paypal'
      end

      app.config.payment_gateways << ::PaypalPayment

      app.config.assets.precompile += %w[paypal_payment_manifest.js]
    end
  end
end
