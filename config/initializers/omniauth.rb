unless Rails.env.test? || Figaro.env.building_docker_image
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :steam, Figaro.env.steam_web_api_key!
    provider :discord, Figaro.env.discord_id!, Figaro.env.discord_secret!
  end
end
