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
          render :edit, status: :unprocessable_entity
        end
      end

      def register_for_tournament
        if run Operations::Admin::Tournament::Team::RegisterForTournament
          flash[:success] = _('Admin|Tournaments|Team|Successfully registered for the tournament')
        else
          flash[:danger] = _('Admin|Tournamens|Team|Registering for the tournament failed')
        end
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
      ensure
        redirect_to admin_tournament_path(model.tournament)
      end

      def unregister_from_tournament
        if run Operations::Admin::Tournament::Team::UnregisterFromTournament
          flash[:success] = _('Admin|Tournaments|Team|Successfully unregistered from the tournament')
        else
          flash[:danger] = _('Admin|Tournamens|Team|Unregistering from the tournament failed')
        end
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
      ensure
        redirect_to admin_tournament_path(model.tournament)
      end

      def add_user
        run Operations::Admin::Tournament::Team::AddUser
        flash[:success] = _('Admin|Team|User added to team')
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
      ensure
        redirect_to admin_team_path(model)
      end

      def destroy
        if run Operations::Admin::Tournament::Team::Destroy
          flash[:success] = _('Admin|Team|Successfully destroyed')
        else
          flash[:danger] = _('Admin|Team|Destroying failed')
        end

        redirect_to admin_tournament_path(model.tournament)
      end
    end
  end
end
