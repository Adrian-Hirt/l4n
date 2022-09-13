require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module L4n
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Time tone
    config.time_zone = 'Bern'

    # We don't want remote forms for now (turbo does not work perfectly without it)
    config.form_with_generates_remote_forms = false

    # We want to be able to add new files while keeping the old ones
    config.active_storage.replace_on_assign_to_many = false

    # Array holding the payment gateways
    config.payment_gateways = []
  end
end
