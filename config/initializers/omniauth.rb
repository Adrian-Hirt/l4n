unless Rails.env.test? || Figaro.env.building_docker_image

  # Only configure the providers if the relevant secrets are set
  Rails.application.config.middleware.use OmniAuth::Builder do
    if Figaro.env.steam_web_api_key.present?
      provider :steam, Figaro.env.steam_web_api_key
    end

    if Figaro.env.discord_id.present? && Figaro.env.discord_secret.present?
      provider :discord, Figaro.env.discord_id!, Figaro.env.discord_secret!
    end
  end
end
