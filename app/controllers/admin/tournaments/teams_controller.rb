module Admin
  module Tournaments
    class TeamsController < AdminController
      add_breadcrumb _('Admin|Tournaments'), :admin_tournaments_path

      def index; end

      def new
        op Operations::Admin::Tournament::Team::CreateForTournament
        add_breadcrumb op.tournament.name, admin_tournament_path(op.tournament)
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Tournament|Team') }
      end

      def create
        if run Operations::Admin::Tournament::Team::CreateForTournament
          flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('Tournament|Team') }
          redirect_to admin_tournament_path(op.tournament)
        else
          add_breadcrumb op.tournament.name, admin_tournament_path(op.tournament)
          add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Tournament|Team') }
          flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('Tournament|Team') }
          render :new, status: :unprocessable_entity
        end
      rescue Operations::Admin::Tournament::Team::UserError
        add_breadcrumb op.tournament.name, admin_tournament_path(op.tournament)
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Tournament|Team') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('Tournament|Team') }
        render :new, status: :unprocessable_entity
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
        redirect_to admin_tournament_path(op.tournament)
      end

      def edit
        op Operations::Admin::Tournament::Team::Update
        add_breadcrumb model.tournament.name, admin_tournament_path(model.tournament)
        add_breadcrumb model.name
      end

      def update
        if run Operations::Admin::Tournament::Team::Update
          flash[:success] = _('Admin|%{model_name}|Create failed') % { model_name: _('Tournament|Team') }
          redirect_to admin_tournament_path(model.tournament)
        else
          add_breadcrumb model.tournament.name, admin_tournament_path(model.tournament)
          add_breadcrumb model.name
          flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('Tournament|Team') }
          render :edit, status: :unprocessable_entity
        end
      end

      def register_for_tournament
        if run Operations::Admin::Tournament::Team::RegisterForTournament
          flash[:success] = _('Admin|Tournament|Team|Successfully registered for the tournament')
        else
          flash[:danger] = _('Admin|Tournament|Team|Registering for the tournament failed')
        end
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
      ensure
        redirect_to admin_tournament_path(model.tournament)
      end

      def unregister_from_tournament
        if run Operations::Admin::Tournament::Team::UnregisterFromTournament
          flash[:success] = _('Admin|Tournament|Team|Successfully unregistered from the tournament')
        else
          flash[:danger] = _('Admin|Tournament|Team|Unregistering from the tournament failed')
        end
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
      ensure
        redirect_to admin_tournament_path(model.tournament)
      end

      def add_user
        run Operations::Admin::Tournament::Team::AddUser
        flash[:success] = _('Admin|Tournament|Team|User added to team')
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
      ensure
        redirect_to admin_team_path(model)
      end

      def destroy
        if run Operations::Admin::Tournament::Team::Destroy
          flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('Tournament|Team') }
        else
          flash[:danger] = _('Admin|Tournament|Team|Destroying failed')
        end

        redirect_to admin_tournament_path(model.tournament)
      end
    end
  end
end
