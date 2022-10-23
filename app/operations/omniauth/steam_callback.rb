module Operations::Omniauth
  class SteamCallback < RailsOps::Operation
    without_authorization

    def perform
      steam_id = context.view.request.env['omniauth.auth'].extra['raw_info']['steamid']
      context.user.steam_id = steam_id
      context.user.save!
    end
  end
end
