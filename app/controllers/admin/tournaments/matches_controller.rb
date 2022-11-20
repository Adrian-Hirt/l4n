module Admin
  module Tournaments
    class MatchesController < AdminController
      add_breadcrumb _('Admin|Tournaments'), :admin_tournaments_path

      def show
        op Operations::Admin::Tournament::Match::Load
        add_breadcrumb model.phase.tournament.name, admin_tournament_path(model.phase.tournament)
        add_breadcrumb "#{model.phase.phase_number}. #{model.phase.name}", admin_phase_path(model.phase)
        add_breadcrumb _('Admin|Tournament|Match')
      end

      def update
        if run Operations::Admin::Tournament::Match::Update
          flash[:success] = _('Admin|%{model_name}|Create failed') % { model_name: _('Tournament|Match') }
          redirect_to admin_phase_path(model.phase)
        else
          flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('Tournament|Match') }
          add_breadcrumb model.phase.tournament.name, admin_tournament_path(model.phase.tournament)
          add_breadcrumb "#{model.phase.phase_number}. #{model.phase.name}", admin_phase_path(model.phase)
          add_breadcrumb _('Admin|Tournament|Match')
          render :show, status: :unprocessable_entity
        end
      rescue Operations::Admin::Tournament::Match::MatchNotInRunningPhase
        flash[:danger] = _('Admin|Tournament|Match|Not in running phase')
        redirect_to admin_phase_path(model.phase)
      rescue Operations::Admin::Tournament::Match::MatchNotInCurrentRound
        flash[:danger] = _('Admin|Tournament|Match|Not in current round')
        redirect_to admin_phase_path(model.phase)
      end
    end
  end
end
