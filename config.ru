# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'localhost/authority' if Rails.env.development?

run Rails.application
Rails.application.load_server
