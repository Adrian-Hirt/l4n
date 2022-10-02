unless Rails.env.test? || ENV['RUNNING_ON_HEROKU'].present?
  Figaro.require_keys(%w[
                        paypal_id
                        paypal_secret
                      ])
end
