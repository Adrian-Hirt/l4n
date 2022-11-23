unless Rails.env.test? || Figaro.env.building_docker_image
  Hcaptcha.configure do |config|
    config.site_key = Figaro.env.hcaptcha_site_key!
    config.secret_key = Figaro.env.hcaptcha_site_secret!
  end
end
