require 'httparty'

module Operations::Gameaccounts
  class ShowDiscord < RailsOps::Operation
    schema3 do
      int! :id, cast_str: true
    end

    policy :on_init do
      authorize! :read_public, user
    end

    attr_accessor :data
    attr_accessor :successful

    def perform
      if user.discord_id.blank?
        @successful = false
        return
      end

      if Figaro.env.discord_bot_auth.blank?
        @successful = false
        return
      end

      response = HTTParty.get("https://discordapp.com/api/users/#{user.discord_id}", headers: { 'Authorization' => Figaro.env.discord_bot_auth! })

      if response.code == 200
        @successful = true
        @data = {}
        @data[:discord_name] = "#{response['username']}##{response['discriminator']}"
        @data[:discord_avatar] = "https://cdn.discordapp.com/avatars/#{user.discord_id}/#{response['avatar']}.png" if response['avatar'].present?
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
