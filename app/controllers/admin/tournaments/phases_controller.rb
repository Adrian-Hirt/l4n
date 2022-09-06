module Admin
  module Tournaments
    class PhasesController < AdminController
      add_breadcrumb _('Admin|Tournaments'), :admin_tournaments_path

      def show
        op Operations::Admin::Tournament::Phase::Load
        add_breadcrumb model.tournament.name, admin_tournament_path(model.tournament)
        add_breadcrumb "#{model.phase_number}. #{model.name}"
      end

      def new
        op Operations::Admin::Tournament::Phase::CreateForTournament
        add_breadcrumb op.tournament.name, admin_tournament_path(op.tournament)
        add_breadcrumb _('Admin|Tournaments|Phase|New')
      end

      def create
        if run Operations::Admin::Tournament::Phase::CreateForTournament
          flash[:success] = _('Admin|Tournaments|Phase|Successfully created')
          redirect_to admin_tournament_path(op.tournament)
        else
          add_breadcrumb op.tournament.name, admin_tournament_path(op.tournament)
          add_breadcrumb _('Admin|Tournaments|Phase|New')
          flash[:danger] = _('Admin|Tournamens|Phase|Create failed')
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        op Operations::Admin::Tournament::Phase::Update
        add_breadcrumb model.tournament.name, admin_tournament_path(model.tournament)
        add_breadcrumb model.name
      end

      def update
        if run Operations::Admin::Tournament::Phase::Update
          flash[:success] = _('Admin|Tournaments|Phase|Successfully updated')
          redirect_to admin_tournament_path(model.tournament)
        else
          add_breadcrumb model.tournament.name, admin_tournament_path(model.tournament)
          add_breadcrumb model.name
          flash[:danger] = _('Admin|Tournamens|Phase|Update failed')
          render :new, status: :unprocessable_entity
        end
      end

      def destroy
        # TODO: Make sure tournaments are in a deletable state & all dependent
        # models get cleaned up properly
        fail NotImplementedError
        # if run Operations::Admin::Tournament::Phase::Destroy
        #   # handle successful case
        # else
        #   # handle error case
        # end
      end

      def generate_rounds
        if run Operations::Admin::Tournament::Phase::GenerateRounds
          flash[:success] = _('Admin|Tournaments|Phase|Successfully generated rounds')
        else
          flash[:danger] = _('Admin|Tournaments|Phase|Generating rounds failed')
        end
      rescue Operations::Admin::Tournament::Phase::NoTeamsPresent
        flash[:danger] = _('Admin|Tournaments|Phase|Cannot generate rounds without any seedable teams')
      rescue Operations::Admin::Tournament::Phase::RoundsAlreadyGenerated
        flash[:danger] = _('Admin|Tournaments|Phase|Rounds have already been generated')
      ensure
        redirect_to admin_phase_path(model)
      end

      def update_seeding
        if run Operations::Admin::Tournament::Phase::UpdateSeeding
          flash[:success] = _('Admin|Tournaments|Phase|Successfully updated seeding')
        else
          flash[:danger] = _('Admin|Tournaments|Phase|Failed to update seeding')
        end
        redirect_to admin_phase_path(model)
      end

      def confirm_seeding
        if run Operations::Admin::Tournament::Phase::ConfirmSeeding
          flash[:success] = _('Admin|Tournaments|Phase|Successfully confirmed seeding')
        else
          flash[:danger] = _('Admin|Tournaments|Phase|Failed to confirm seeding')
        end
        redirect_to admin_phase_path(model)
      end

      def generate_next_round_matches
        if run Operations::Admin::Tournament::Phase::GenerateNextRoundMatches
          flash[:success] = _('Admin|Tournaments|Phase|Successfully generated next round matches')
        else
          flash[:danger] = _('Admin|Tournaments|Phase|Failed to generate next round matches')
        end
      rescue Operations::Admin::Tournament::Phase::NotAllMatchesFinished
        flash[:danger] = _('Admin|Tournaments|Phase|Please first finish all the matches of the current round')
      rescue Operations::Admin::Tournament::Phase::NoNextRound
        flash[:danger] = _('Admin|Tournaments|Phase|No next round to generate the matches for')
      ensure
        redirect_to admin_phase_path(model)
      end

      def complete
        if run Operations::Admin::Tournament::Phase::Complete
          flash[:success] = _('Admin|Tournaments|Phase|Successfully completed the phase')
        else
          flash[:danger] = _('Admin|Tournaments|Phase|Failed to complete the phase')
        end
      rescue Operations::Admin::Tournament::Phase::WrongStatus
        flash[:danger] = _('Admin|Tournaments|Phase|Wrong status to complete the phase')
      rescue Operations::Admin::Tournament::Phase::UncompletedMatches
        flash[:danger] = _('Admin|Tournaments|Phase|Not all matches are completed')
      ensure
        redirect_to admin_phase_path(model)
      end
    end
  end
end
