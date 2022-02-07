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

    # Needed to allow "namespacing" Grids, Operations, Queries and Services
    # Need to find a better way (easier way => put one level deeper, e.g.
    # grids not in app/grids, but in app/grids/grids)
    # rubocop:disable Rails/FilePath
    config.eager_load_paths.delete("#{Rails.root}/app/grids")
    config.eager_load_paths.delete("#{Rails.root}/app/operations")
    config.eager_load_paths.delete("#{Rails.root}/app/queries")
    config.eager_load_paths.delete("#{Rails.root}/app/services")
    config.eager_load_paths.unshift("#{Rails.root}/app")

    Rails.autoloaders.main.ignore("#{Rails.root}/app/assets")
    Rails.autoloaders.main.ignore("#{Rails.root}/app/javascript")
    Rails.autoloaders.main.ignore("#{Rails.root}/app/views")
    # rubocop:enable Rails/FilePath

    config.time_zone = 'Bern'

    config.form_with_generates_remote_forms = false
    config.active_storage.replace_on_assign_to_many = false

    config.payment_gateways = []
  end
end
