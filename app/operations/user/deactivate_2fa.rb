module Operations::User
  class Deactivate2fa < RailsOps::Operation
    without_authorization

    def perform
      context.user.two_factor_enabled = false
      context.user.save
    end
  end
end
