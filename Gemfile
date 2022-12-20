source 'https://rubygems.org'

ruby '3.1.2'

# Rails and rails-y stuff
gem 'bootsnap', '>= 1.4.4', require: false
gem 'rails', '~> 7.0.4'

# Authentication & Authorization
gem 'cancancan', '~> 3.4.0'
gem 'devise', '~> 4.8'
gem 'devise-two-factor', '~> 5.0.0'
gem 'doorkeeper', '~> 5.6.2'
gem 'recaptcha', '~> 5.12.3'

# Session handling
gem 'activerecord-session_store', '~> 2.0.0'

# Puma
gem 'localhost', require: false
gem 'puma', '~> 5.6'

# Database
gem 'pg', '~> 1.4.3'

# Assets
gem 'cssbundling-rails', '~> 1.1.1'
gem 'jsbundling-rails', '~> 1.0.3'
gem 'sprockets-rails', '~> 3.4.1'
gem 'stimulus-rails', '~> 1.1.0'
gem 'turbo-rails', '~> 1.3.2'

# Application structure
gem 'active_type', '~> 2.3.0' # Need to lock as 2.0 somehow does not work with rails_ops
gem 'inquery', '~> 1.0.9'
gem 'rails_ops', '~> 1.2.0'
gem 'schemacop', '~> 3.0.11'

# Views
gem 'breadcrumbs_on_rails', '~> 4.1.0'
gem 'cocoon', '~> 1.2.15'
gem 'datagrid', '~> 1.6.3'
gem 'haml-rails', '~> 2.0'
gem 'kaminari', '~> 1.2.1'
gem 'rqrcode', '~> 2.1.0'
gem 'simple_form', '~> 5.1.0'

# Translations
gem 'gettext_i18n_rails', '~> 1.9.0'
gem 'mobility', '~> 1.2.5'
gem 'rails-i18n', '~> 7.0.1'

# Markdown rendering
gem 'redcarpet', '~> 3.5.1'

# Settings
gem 'figaro', '1.2.0'
gem 'rails-settings-cached', '~> 2.8.2'

# Attachments
gem 'active_storage_validations', '~> 1.0.2'
gem 'image_processing', '~> 1.12'

# Models
gem 'money-rails', '~>1.12'

# Background processing
gem 'whenever', '~> 1.0.0', require: false

# Tournaments
gem 'tournament-system', '~> 2', require: 'tournament_system'

# OAuth
gem 'omniauth', '~> 2.0.4'
gem 'omniauth-discord', '~> 1.0.2'
gem 'omniauth-rails_csrf_protection', '~> 1.0.1'
gem 'omniauth-steam', '~> 1.0.6'

# Notifications
gem 'exception_notification', '~> 4.5.0'

# Development gems
group :development do
  gem 'listen', '~> 3.2'
  gem 'pry-byebug', '~> 3.9'

  # Translations
  gem 'gettext', '>=3.0.2', require: false
  gem 'ruby_parser', require: false

  # Code analysis and standards
  gem 'rubocop', '~> 1.24'
  gem 'rubocop-performance', '~> 1.13'
  gem 'rubocop-rails', '~> 2.13'

  # Security
  gem 'bundler-audit', '~> 0.9.0'

  # Payment gateways
  gem 'dummy_payment', path: 'payment_gateways/dummy_payment'
end

# Test gems
group :test do
  gem 'simplecov', '~> 0.21.2', require: false
  gem 'simplecov-lcov', '~> 0.8.0', require: false
end

# Payment gateways
gem 'paypal_payment', path: 'payment_gateways/paypal_payment'
gem 'seki_payment', path: 'payment_gateways/seki_payment'
