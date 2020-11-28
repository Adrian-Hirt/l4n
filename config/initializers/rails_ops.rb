# Replace this with your authorization backend.
require 'rails_ops/authorization_backend/can_can_can'

RailsOps.configure do |config|
  # Replace this with your authorization backend.
  config.authorization_backend = 'RailsOps::AuthorizationBackend::CanCanCan'
end
