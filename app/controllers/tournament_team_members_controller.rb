class TournamentTeamMembersController < ApplicationController
  before_action :authenticate_user!

  def destroy
    if run Operations::Tournament::TeamMember::Destroy
      flash[:success] = _('Team|Successfully deleted')
    else
      flash[:danger] = _('Team|Could not be deleted')
    end

    redirect_to tournament_path(model)
  rescue Operations::Exceptions::OpFailed => e
    flash[:danger] = e.message
    redirect_to tournament_path(model)
  end

  def promote
    if run Operations::Tournament::TeamMember::Promote
      flash[:success] = _('TeamMember|Successfully promoted')
    else
      flash[:danger] = _('TeamMember|Promoting failed')
    end

    redirect_to tournament_team_path(model)
  rescue Operations::Exceptions::OpFailed => e
    flash[:danger] = e.message
    redirect_to tournament_path(model)
  end
end
