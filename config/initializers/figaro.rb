if Rails.env.development? && !Figaro.env.building_docker_image
  Figaro.require_keys(%w[
                        hcaptcha_site_key
                        hcaptcha_site_secret
                        steam_web_api_key
                        discord_id
                        discord_secret
                        discord_bot_auth
                      ])
end
