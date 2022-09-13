class TournamentTeamsController < ApplicationController
  def index
    op Operations::Tournament::Team::Index
  end

  def show
    op Operations::Tournament::Team::Load
  end

  def create
    if run Operations::Tournament::Team::CreateForTournament
      flash[:success] = _('Team|Successfully created')
    else
      flash[:danger] = model.errors.full_messages.to_sentence
    end

    redirect_back(fallback_location: tournament_path(op.tournament))
  rescue Operations::Exceptions::OpFailed => e
    flash[:danger] = e.message
    redirect_back(fallback_location: tournament_path(op.tournament))
  end

  def update
    if run Operations::Tournament::Team::Update
      flash[:success] = _('Team|Successfully updated')
    else
      flash[:danger] = model.errors.full_messages.to_sentence
    end

    redirect_to tournament_path(model)
  rescue Operations::Exceptions::OpFailed => e
    flash[:danger] = e.message
    redirect_to tournament_path(model)
  end

  def destroy
    if run Operations::Tournament::Team::Destroy
      flash[:success] = _('Team|Successfully deleted')
    else
      flash[:danger] = _('Team|Could not be deleted')
    end

    redirect_to tournament_path(model)
  rescue Operations::Exceptions::OpFailed => e
    flash[:danger] = e.message
    redirect_to tournament_path(model)
  end

  def register_for_tournament
    if run Operations::Tournament::Team::RegisterForTournament
      flash[:success] = _('Team|Successfully registered for tournament')
    else
      flash[:danger] = _('Team|Could not be registered for tournament')
    end

    redirect_to tournament_path(model)
  rescue Operations::Exceptions::OpFailed => e
    flash[:danger] = e.message
    redirect_to tournament_path(model)
  end

  def unregister_from_tournament
    if run Operations::Tournament::Team::UnregisterFromTournament
      flash[:success] = _('Team|Successfully unregistered from tournament')
    else
      flash[:danger] = _('Team|Could not be registered for tournament')
    end

    redirect_to tournament_path(model)
  rescue Operations::Exceptions::OpFailed => e
    flash[:danger] = e.message
    redirect_to tournament_path(model)
  end

  def join
    if run Operations::Tournament::Team::Join
      flash[:success] = _('Team|Successfully joined')
    else
      flash[:danger] = _('Team|Could not join')
    end

    redirect_to tournament_path(model)
  rescue Operations::Exceptions::OpFailed => e
    flash[:danger] = e.message
    redirect_to tournament_path(model)
  end
end
