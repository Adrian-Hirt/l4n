if Rails.env.development?
  Figaro.require_keys(%w[
                        recaptcha_site_key
                        recaptcha_site_secret
                      ])
end
