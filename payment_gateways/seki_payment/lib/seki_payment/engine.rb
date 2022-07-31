module SekiPayment
  class Engine < ::Rails::Engine
    isolate_namespace SekiPayment

    initializer 'seki_payment.configuration' do |app|
      app.routes.append do
        mount SekiPayment::Engine => '/paymentgateway/seki'
      end

      app.config.payment_gateways << ::SekiPayment

      app.config.assets.precompile += %w[seki_payment_manifest.js]
    end
  end
end
