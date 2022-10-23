require 'httparty'

module Operations::Gameaccounts
  class ShowDiscord < RailsOps::Operation
    schema3 {} # No params

    # Uses context user, so no need to authorize
    without_authorization

    attr_accessor :data
    attr_accessor :successful

    def perform
      if context.user.discord_id.blank?
        @successful = false
        return
      end

      response = HTTParty.get("https://discordapp.com/api/users/#{context.user.discord_id}", headers: { 'Authorization' => Figaro.env.discord_bot_auth })

      if response.code == 200
        @successful = true
        @data = {}
        @data[:discord_name] = "#{response['username']}##{response['discriminator']}"
        @data[:discord_avatar] = "https://cdn.discordapp.com/avatars/#{context.user.discord_id}/#{response['avatar']}.png" if response['avatar'].present?
      else
        @successful = false
      end
    end
  end
end
