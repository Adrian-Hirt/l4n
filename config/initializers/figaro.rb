unless Rails.env.test?
  Figaro.require_keys(%w[
                        hcaptcha_site_key
                        hcaptcha_site_secret
                      ])
end
