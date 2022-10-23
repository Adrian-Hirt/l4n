module Operations::Gameaccounts
  class RemoveSteam < RailsOps::Operation
    schema3 {} # No params

    # Uses context user, so no need to authorize
    without_authorization

    def perform
      context.user.steam_id = nil
      context.user.save!
    end
  end
end
