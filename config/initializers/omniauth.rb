unless Rails.env.test? || Figaro.env.building_docker_image

  # Only configure the providers if the relevant secrets are set
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :steam, Figaro.env.steam_web_api_key if Figaro.env.steam_web_api_key.present?

    provider :discord, Figaro.env.discord_id!, Figaro.env.discord_secret! if Figaro.env.discord_id.present? && Figaro.env.discord_secret.present?
  end
end
