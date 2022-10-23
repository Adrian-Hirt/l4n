class OmniauthController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def steam_callback
    run Operations::Omniauth::SteamCallback
    flash[:success] = _('User|Steam account successfully added')
    redirect_to settings_gameaccounts_path
  end

  def discord_callback
    run Operations::Omniauth::DiscordCallback
    flash[:success] = _('User|Discord account successfully added')
    redirect_to settings_gameaccounts_path
  end
end
