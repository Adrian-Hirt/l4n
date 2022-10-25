require 'httparty'

module Operations::Gameaccounts
  class ShowSteam < RailsOps::Operation
    schema3 do
      int! :id, cast_str: true
    end

    policy :on_init do
      authorize! :read, user
    end

    attr_accessor :data
    attr_accessor :successful

    def perform
      if user.steam_id.blank?
        @successful = false
        return
      end

      steam_url = "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{Figaro.env.steam_web_api_key}&steamids=#{user.steam_id}"
      response = HTTParty.get(steam_url)

      if response.code == 200
        @successful = true
        @data = {}
        @data[:steam_name] = response['response']['players'][0]['personaname']
        @data[:steam_url] = response['response']['players'][0]['profileurl']
        @data[:steam_avatar] = response['response']['players'][0]['avatarfull']
        @data[:steam_status_id] = response['response']['players'][0]['personastate']
        @data[:steam_game] = response['response']['players'][0]['gameextrainfo']
        @data[:steam_ip] = response['response']['players'][0]['gameserverip']

        # 0 - Offline, 1 - Online, 2 - Busy, 3 - Away, 4 - Snooze, 5 - looking to trade, 6 - looking to play
        case @data[:steam_status_id]
        when 0
          @data[:steam_status] = _('SteamStatus|Offline')
        when 1
          @data[:steam_status] = _('SteamStatus|Online')
        when 2
          @data[:steam_status] = _('SteamStatus|Busy')
        when 3
          @data[:steam_status] = _('SteamStatus|Away')
        when 4
          @data[:steam_status] = _('SteamStatus|Snooze')
        when 5
          @data[:steam_status] = _('SteamStatus|Looking to trade')
        when 6
          @data[:steam_status] = _('SteamStatus|Looking to play')
        end
      else
        @successful = false
      end
    end

    private

    def user
      @user ||= ::User.find(osparams.id)
    end
  end
end
