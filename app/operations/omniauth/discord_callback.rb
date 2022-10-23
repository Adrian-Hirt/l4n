module Operations::Omniauth
  class DiscordCallback < RailsOps::Operation
    without_authorization

    def perform
      discord_id = context.view.request.env['omniauth.auth'].extra['raw_info']['id']
      context.user.discord_id = discord_id
      context.user.save!
    end
  end
end
