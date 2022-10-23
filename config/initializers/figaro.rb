unless Rails.env.test? || ENV['RUNNING_ON_HEROKU'].present?
  Figaro.require_keys(%w[
                        hcaptcha_site_key
                        hcaptcha_site_secret
                        steam_web_api_key
                        discord_id
                        discord_secret
                        discord_bot_auth
                      ])
end
