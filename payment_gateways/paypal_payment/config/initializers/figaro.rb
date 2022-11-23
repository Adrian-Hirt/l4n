if Rails.env.development?
  Figaro.require_keys(%w[
                        paypal_id
                        paypal_secret
                      ])
end
