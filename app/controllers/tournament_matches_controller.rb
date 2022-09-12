class TournamentMatchesController < ApplicationController
  def edit
    op Operations::Tournament::Match::Update
  end

  def update
    if run Operations::Tournament::Match::Update
      flash.now[:success] = _('Team|Result updated')
    else
      flash.now[:danger] = _('Team|Result could not be updated')
    end
    render :edit, status: :unprocessable_entity
  rescue Operations::Exceptions::OpFailed => e
    flash[:danger] = e.message
    redirect_to tournament_path(model.tournament)
  end
end