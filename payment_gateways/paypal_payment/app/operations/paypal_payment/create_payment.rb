module PaypalPayment
  class CreatePayment < PaypalOperation
    schema3 do
      str! :order_id
    end

    attr_accessor :payment_id

    def perform
      order_data = Operations::PaymentGateway::GetPaymentInfo.run!(order_id: osparams.order_id).result

      create_payment(order_data)
    end

    private

    def create_payment(order_data)
      items = []

      order_data[:items].each do |item|
        items << {
          quantity:    item[:quantity],
          name:        item[:product],
          price:       item[:price].format(symbol: false, decimal_mark: '.'),
          currency:    'CHF',
          description: item[:product]
        }
      end

      order_data[:promotion_codes].each do |promotion_code|
        items << {
          quantity:    1,
          name:        promotion_code[:name],
          price:       (-promotion_code[:reduction]).format(symbol: false, decimal_mark: '.'),
          currency:    'CHF',
          description: promotion_code[:name]
        }
      end

      body = {
        intent:        'sale',
        redirect_urls: {
          return_url: context.view.request.base_url,
          cancel_url: context.view.request.base_url
        },
        payer:         {
          payment_method: 'paypal'
        },
        transactions:  [
          amount:         {
            total:    order_data[:total].format(symbol: false, decimal_mark: '.'),
            currency: 'CHF',
            details:  {
              subtotal: order_data[:total].format(symbol: false, decimal_mark: '.')
            }
          },
          item_list:      {
            items: items
          },
          description:    format(_('PaypalPaymentGateway|Order description for %{order_id}'), order_id: order_data[:real_order_id]),
          invoice_number: SecureRandom.hex
        ]
      }

      response = HTTParty.post(
        payment_url,
        body:    body.to_json,
        headers: {
          'Content-Type'  => 'application/json',
          'Authorization' => "Bearer #{oauth_token}"
        }
      )

      @payment_id = response['id']
    end

    def payment_url
      if Rails.env.development?
        'https://api.sandbox.paypal.com/v1/payments/payment'
      else
        'https://api.paypal.com/v1/payments/payment'
      end
    end
  end
end
