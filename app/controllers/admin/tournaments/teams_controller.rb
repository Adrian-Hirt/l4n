module Admin
  module Tournaments
    class TeamsController < AdminController
      add_breadcrumb _('Admin|Tournaments'), :admin_tournaments_path

      def index; end

      def new
        op Operations::Admin::Tournament::Team::CreateForTournament
        add_breadcrumb op.tournament.name, admin_tournament_path(op.tournament)
        add_breadcrumb _('Admin|Tournaments|Team|New')
      end

      def create
        if run Operations::Admin::Tournament::Team::CreateForTournament
          flash[:success] = _('Admin|Tournaments|Team|Successfully created')
          redirect_to admin_tournament_path(op.tournament)
        else
          add_breadcrumb op.tournament.name, admin_tournament_path(op.tournament)
          add_breadcrumb _('Admin|Tournaments|Team|New')
          flash[:danger] = _('Admin|Tournamens|Team|Create failed')
          render :new, status: :unprocessable_entity
        end
      rescue Operations::Admin::Tournament::Team::TournamentHasOngoingPhases
        flash[:danger] = _('Admin|Tournaments|Team|No new teams can be created')
        redirect_to admin_tournament_path(op.tournament)
      end

      def edit
        op Operations::Admin::Tournament::Team::Update
        add_breadcrumb model.tournament.name, admin_tournament_path(model.tournament)
        add_breadcrumb model.name
      end

      def update
        if run Operations::Admin::Tournament::Team::Update
          flash[:success] = _('Admin|Tournaments|Team|Successfully updated')
          redirect_to admin_tournament_path(model.tournament)
        else
          add_breadcrumb model.tournament.name, admin_tournament_path(model.tournament)
          add_breadcrumb model.name
          flash[:danger] = _('Admin|Tournamens|Team|Update failed')
          render :new, status: :unprocessable_entity
        end
      end

      def register_for_tournament
        if run Operations::Admin::Tournament::Team::RegisterForTournament
          flash[:success] = _('Admin|Tournaments|Team|Successfully registered for the tournament')
        else
          flash[:danger] = _('Admin|Tournamens|Team|Registering for the tournament failed')
        end
      rescue Operations::Admin::Tournament::Team::CannotBeRegistered
        flash[:danger] = _('Admin|Tournamens|Team|Team cannot be registered as it has the wrong status')
      rescue Operations::Admin::Tournament::Team::TournamentIsFull
        flash[:danger] = _('Admin|Tournamens|The tournament is full')
      rescue Operations::Admin::Tournament::Team::TournamentHasOngoingPhases
        flash[:danger] = _('Admin|Tournamens|The tournament has ongoing phases')
      ensure
        redirect_to admin_tournament_path(model.tournament)
      end

      def unregister_from_tournament
        if run Operations::Admin::Tournament::Team::UnregisterFromTournament
          flash[:success] = _('Admin|Tournaments|Team|Successfully unregistered from the tournament')
        else
          flash[:danger] = _('Admin|Tournamens|Team|Unregistering from the tournament failed')
        end
      rescue Operations::Admin::Tournament::Team::NotRegistered
        flash[:danger] = _('Admin|Tournamens|Team|Team is not registered for the tournament')
      rescue Operations::Admin::Tournament::Team::AlreadySeeded
        flash[:danger] = _('Admin|Tournamens|Team|Team is already seeded')
      rescue Operations::Admin::Tournament::Team::TournamentHasOngoingPhases
        flash[:danger] = _('Admin|Tournamens|The tournament has ongoing phases')
      ensure
        redirect_to admin_tournament_path(model.tournament)
      end

      def destroy
        # TODO: Make sure tournaments are in a deletable state & all dependent
        # models get cleaned up properly
        fail NotImplementedError
        # if run Operations::Admin::Tournament::Team::Destroy
        #   # handle successful case
        # else
        #   # handle error case
        # end
      end
    end
  end
end
