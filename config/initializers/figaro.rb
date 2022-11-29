if Rails.env.development? && !Figaro.env.building_docker_image
  Figaro.require_keys(%w[
                        recaptcha_site_key
                        recaptcha_site_secret
                      ])
end
