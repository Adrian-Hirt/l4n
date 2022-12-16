module PaypalPayment
  class ExecutePayment < PaypalOperation
    schema3 do
      str! :paymentID
      str! :payerID
      str! :order_id
    end

    def perform
      # Get data from the backend about the payment
      begin
        result = Operations::PaymentGateway::GetPaymentInfo.run!(order_id: osparams.order_id).result

        # Check that the order is still valid
        fail ExecutionFailed, _('PaypalPaymentGateway|Order is expired, payment was not executed') if result[:valid_until] <= Time.zone.now
      rescue Operations::PaymentGateway::InvalidOrder => e
        fail ExecutionFailed, e.message
      end

      # Execute the payment
      response = execute_payment

      fail ExecutionFailed, _('PaypalPaymentGateway|Payment could not be executed') unless response['state'] == 'approved'

      # If the payment is approved, mark the order as paid
      run_sub Operations::PaymentGateway::SubmitPaymentResult, { gateway_name: 'Paypal Payment', payment_id: osparams.paymentID, order_id: osparams.order_id }

      # Return true
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
