module DummyPayment
  class Engine < ::Rails::Engine
    isolate_namespace DummyPayment

    initializer 'dummy_payment.configuration' do |app|
      app.routes.append do
        mount DummyPayment::Engine => '/paymentgateway/dummy'
      end

      app.config.payment_gateways << ::DummyPayment

      app.config.assets.precompile += %w[dummy_payment_manifest.js]
    end
  end
end
