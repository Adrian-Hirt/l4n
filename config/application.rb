require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module L4n
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    # Load all we have in '/app'
    config.paths = Rails::Paths::Root.new(Rails.root)
    config.paths.add 'app/models', eager_load: true
    config.paths.add 'app', eager_load: true

    config.time_zone = 'Bern'

    config.form_with_generates_remote_forms = false

    config.payment_gateways = []
  end
end
