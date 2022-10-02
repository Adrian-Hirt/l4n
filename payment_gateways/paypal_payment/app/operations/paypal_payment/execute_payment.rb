module PaypalPayment
  class ExecutePayment < PaypalOperation
    schema3 do
      str! :paymentID
      str! :payerID
      str! :order_id
    end

    def perform
      # Execute the payment
      response = execute_payment

      fail ExecutionFailed unless response['state'] == 'approved'

      # If the payment is approved, mark the order as paid
      run_sub Operations::PaymentGateway::SubmitPaymentResult, { gateway_name: 'Paypal Payment', payment_id: osparams.paymentID, order_id: osparams.order_id }
      true
    end

    private

    def execute_payment
      body = {
        payer_id: osparams.payerID
      }

      HTTParty.post(
        payment_url,
        body:    body.to_json,
        headers: {
          'Content-Type'  => 'application/json',
          'Authorization' => "Bearer #{oauth_token}"
        }
      )
    end

    def payment_url
      if Rails.env.development?
        "https://api.sandbox.paypal.com/v1/payments/payment/#{osparams.paymentID}/execute/"
      else
        "https://api.paypal.com/v1/payments/payment/#{osparams.paymentID}/execute/"
      end
    end
  end

  class ExecutionFailed < StandardError; end
end
