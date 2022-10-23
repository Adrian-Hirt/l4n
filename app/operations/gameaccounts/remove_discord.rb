module Operations::Gameaccounts
  class RemoveDiscord < RailsOps::Operation
    schema3 {} # No params

    # Uses context user, so no need to authorize
    without_authorization

    def perform
      context.user.discord_id = nil
      context.user.save!
    end
  end
end
