if Rails.env.development? && !Figaro.env.building_docker_image
  Figaro.require_keys(%w[
                        paypal_id
                        paypal_secret
                      ])
end
