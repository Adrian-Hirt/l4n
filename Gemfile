source 'https://rubygems.org'

ruby '3.0.3'

# Rails and rails-y stuff
gem 'bootsnap', '>= 1.4.4', require: false
gem 'rails', '~> 7.0.0.rc3'

# Authentication & Authorization
gem 'active_model_otp', '~> 2.1.1'
gem 'bcrypt', '~> 3.1.7'
gem 'cancancan', '~> 3.1.0'
gem 'hcaptcha', '~> 7.1'

# Session handling
gem 'activerecord-session_store', '~> 2.0.0'

# Puma
gem 'puma', '~> 5.0'

# Database
gem 'pg', '~> 1.2.3'

# Assets
gem 'cssbundling-rails', '~> 0.2.7'
gem 'importmap-rails', '~> 0.9.2'
gem 'sprockets-rails', '~> 3.4.1'
gem 'stimulus-rails', '~> 0.7.3'
gem 'turbo-rails', '~> 0.9.0'

# Application structure
gem 'active_type', '~> 1.10.1' # Need to lock as 2.0 somehow does not work with rails_ops
gem 'inquery', '~> 1.0.9'
gem 'rails_ops', '~> 1.1.20'
gem 'schemacop', '~> 3.0.11'

# Views
gem 'breadcrumbs_on_rails', '~> 4.1.0'
gem 'cocoon', '~> 1.2.15'
gem 'datagrid', '~> 1.6.3'
gem 'haml-rails', '~> 2.0'
gem 'kaminari', '~> 1.2.1'
gem 'rqrcode', '~> 2.0.0'
gem 'simple_form', '~> 5.1.0'

# Code analysis and standards
gem 'rubocop', '~> 0.86'

# Translations
gem 'gettext_i18n_rails', '~> 1.8.1'
gem 'mobility', '~> 1.2.5'
gem 'rails-i18n', '~> 7.0.1'

# Markdown rendering
gem 'redcarpet', '~> 3.5.1'

# Security
gem 'bundler-audit', '0.7.0.1'

# Settings
gem 'figaro', '1.2.0'

# Attachments
gem 'image_processing', '~> 1.2'

# Development gems
group :development do
  gem 'listen', '~> 3.2'
  gem 'pry-byebug', '~> 3.9'

  gem 'gettext', '>=3.0.2', require: false
  gem 'ruby_parser', require: false
end

# Test gems
group :test do
  gem 'simplecov', '~> 0.21.2', require: false
  gem 'simplecov-lcov', '~> 0.8.0', require: false
end
