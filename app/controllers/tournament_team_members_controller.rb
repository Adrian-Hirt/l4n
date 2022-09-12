class TournamentTeamMembersController < ApplicationController
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
      flash[:success] = _('Admin|TeamMember|Successfully promoted')
    else
      flash[:danger] = _('Admin|TeamMember|Promoting failed')
    end

    redirect_to tournament_team_path(model)
  rescue Operations::Exceptions::OpFailed => e
    flash[:danger] = e.message
    redirect_to tournament_path(model)
  end
end