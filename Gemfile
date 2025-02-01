source 'https://rubygems.org'

ruby '3.3.6'

# Rails and rails-y stuff
gem 'bootsnap', '>= 1.18.4', require: false
gem 'rails', '~> 8.0.1'

# Authentication & Authorization
gem 'cancancan', '~> 3.6.0'
gem 'devise', '~> 4.9'
gem 'devise-two-factor', '~> 6.1.0'
gem 'doorkeeper', '~> 5.8.1'
gem 'doorkeeper-openid_connect', '~> 1.8.10'
gem 'recaptcha', '~> 5.18.0'

# Session handling
gem 'activerecord-session_store', '~> 2.1.0'

# Puma
gem 'puma', '~> 6.5'

# Database
gem 'pg', '~> 1.5.9'

# Assets
gem 'cssbundling-rails', '~> 1.4.0'
gem 'jsbundling-rails', '~> 1.3.0'
gem 'sprockets-rails', '~> 3.5.1'
gem 'stimulus-rails', '~> 1.3.0'
gem 'turbo-rails', '~> 2.0.11'

# Application structure
gem 'active_type', '~> 2.6.0'
gem 'inquery', '~> 1.0.9'
gem 'rails_ops', '~> 1.5.8'
gem 'schemacop', '~> 3.0.11'

# Views
gem 'breadcrumbs_on_rails', '~> 4.1.0'
gem 'cocoon', '~> 1.2.15'
gem 'datagrid', '~> 1.8.0' # TODO: update to 2.0
gem 'haml-rails', '~> 2.0'
gem 'kaminari', '~> 1.2.1'
gem 'rqrcode', '~> 2.2.0'
gem 'simple_form', '~> 5.3.0'

# Translations
gem 'gettext_i18n_rails', '~> 1.13.0'
gem 'mobility', '~> 1.3.1'
gem 'rails-i18n', '~> 8.0.0'

# Markdown rendering
gem 'redcarpet', '~> 3.6.0'

# Settings
gem 'figaro', '1.2.0'
gem 'rails-settings-cached', '~> 2.9.2'

# Attachments
gem 'active_storage_validations', '~> 1.4.0'
gem 'image_processing', '~> 1.13.0'

# Models
gem 'money-rails', '~>1.12'

# Background processing
gem 'whenever', '~> 1.0.0', require: false

# Tournaments
gem 'tournament-system', '~> 2', require: 'tournament_system'

# OAuth
gem 'omniauth', '~> 2.1.1'
gem 'omniauth-discord', '~> 1.2.0'
gem 'omniauth-rails_csrf_protection', '~> 1.0.1'
gem 'omniauth-steam', '~> 1.0.6'

# Notifications
# TODO: either see that this gets tagged or that I can use something else
gem 'exception_notification', git: 'https://github.com/smartinez87/exception_notification.git', ref: '26441fb'

# Development gems
group :development do
  # Code reloading
  gem 'listen', '~> 3.2'

  # Debugging
  gem 'pry-byebug', '~> 3.9'

  # Application server
  gem 'localhost', require: false

  # Translations
  gem 'gettext', '~> 3.5.0', require: false
  gem 'ruby_parser', require: false

  # Code analysis and standards
  gem 'haml_lint', '~> 0.59.0', require: false
  gem 'rubocop', '~> 1.69.2'
  gem 'rubocop-performance', '~> 1.23.0'
  gem 'rubocop-rails', '~> 2.28.0'

  # Payment gateways
  gem 'dummy_payment', path: 'payment_gateways/dummy_payment'
end

# Test gems
group :test do
  gem 'faker', '~> 3.5.1'
  gem 'simplecov', '~> 0.22.0', require: false
end

# Payment gateways
gem 'paypal_payment', path: 'payment_gateways/paypal_payment'
gem 'seki_payment', path: 'payment_gateways/seki_payment'
