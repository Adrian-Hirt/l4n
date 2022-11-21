require 'httparty'

module PaypalPayment
  class PaypalOperation < RailsOps::Operation
    include ::HTTParty

    without_authorization

    def perform
      # Can't execute this operations, inheriting operations
      # need to implement this themselfes
      fail NotImplementedError
    end

    private

    # Gets an Oauth token to use in the payment requests
    def oauth_token
      @oauth_token ||= begin
        auth = { username: Figaro.env.paypal_id!, password: Figaro.env.paypal_secret! }
        body = {
          'grant_type' => 'client_credentials'
        }

        if Rails.env.development?
          url = 'https://api.sandbox.paypal.com/v1/oauth2/token'
        else
          url = 'https://api.paypal.com/v1/oauth2/token'
        end

        response = HTTParty.post(
          url,
          body:       body,
          headers:    {
            'Accept'       => 'application/json',
            'Content-Type' => 'application/x-www-form-urlencoded'
          },
          basic_auth: auth
        )

        response['access_token']
      end
    end
  end
end
