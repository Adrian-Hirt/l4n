unless Rails.env.test?
  Hcaptcha.configure do |config|
    config.site_key = Figaro.env.hcaptcha_site_key!
    config.secret_key = Figaro.env.hcaptcha_site_secret!
  end
end
