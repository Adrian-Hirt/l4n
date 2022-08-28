module Admin
  module Tournaments
    class PhasesController < AdminController
      add_breadcrumb _('Admin|Tournaments'), :admin_tournaments_path

      def index; end

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
    end
  end
end
