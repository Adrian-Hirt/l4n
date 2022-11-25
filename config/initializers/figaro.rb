if Rails.env.development? && !Figaro.env.building_docker_image
  Figaro.require_keys(%w[
                        hcaptcha_site_key
                        hcaptcha_site_secret
                      ])
end
