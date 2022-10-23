class GameaccountsController < ApplicationController
  def steam
    run Operations::Gameaccounts::ShowSteam
    render layout: false
  end

  def discord
    run Operations::Gameaccounts::ShowDiscord
    render layout: false
  end
end
