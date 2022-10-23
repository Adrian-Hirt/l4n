module Settings
  class GameaccountsController < ApplicationController
    before_action :authenticate_user!

    def index; end

    def remove_steam
      if run Operations::Gameaccounts::RemoveSteam
        flash[:success] = _('Gameaccounts|Steam was removed successfully')
      else
        flash[:danger] = _('Gameaccounts|Steam could not be removed')
      end

      redirect_to settings_gameaccounts_path
    end

    def remove_discord
      if run Operations::Gameaccounts::RemoveDiscord
        flash[:success] = _('Gameaccounts|Discord was removed successfully')
      else
        flash[:danger] = _('Gameaccounts|Discord could not be removed')
      end

      redirect_to settings_gameaccounts_path
    end
  end
end
