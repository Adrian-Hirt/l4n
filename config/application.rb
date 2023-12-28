require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module L4n
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Load the secret key base from figaro if they're not present yet
    credentials.secret_key_base ||= Figaro.env.secret_key_base

    # Time tone
    config.time_zone = 'Bern'

    # We don't want remote forms for now (turbo does not work perfectly without it)
    config.form_with_generates_remote_forms = false

    # ActiveRecord encryption
    config.active_record.encryption.primary_key = Figaro.env.ar_primary_key
    config.active_record.encryption.deterministic_key = Figaro.env.ar_deterministic_key
    config.active_record.encryption.key_derivation_salt = Figaro.env.ar_key_derivation_salt

    # Array holding the payment gateways
    config.payment_gateways = []

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Override layouts for Doorkeeper
    config.to_prepare do
      # Only Authorized Applications
      Doorkeeper::AuthorizedApplicationsController.layout 'application'

      # Only Authorization endpoint
      Doorkeeper::AuthorizationsController.layout 'devise'
    end
  end
end
