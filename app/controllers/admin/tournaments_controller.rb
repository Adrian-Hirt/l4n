module Admin
  class TournamentsController < AdminController
    add_breadcrumb _('Admin|Tournaments'), :admin_tournaments_path

    def index
      op Operations::Admin::Tournament::Index
    end

    def show
      op Operations::Admin::Tournament::Load
      add_breadcrumb model.name
    end

    def new
      op Operations::Admin::Tournament::Create
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Tournament') }
    end

    def create
      if run Operations::Admin::Tournament::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('Tournament') }
        redirect_to admin_tournament_path(model)
      else
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Tournament') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('Tournament') }
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::Tournament::Update
      add_breadcrumb model.name, admin_tournament_path(model)
    end

    def update
      if run Operations::Admin::Tournament::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('Tournament') }
        redirect_to admin_tournament_path(model)
      else
        add_breadcrumb model.name, admin_tournament_path(model)
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('Tournament') }
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::Tournament::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('Tournament') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('Tournament') }
      end
      redirect_to admin_tournaments_path
    end

    def toggle_registration
      if run Operations::Admin::Tournament::ToggleRegistration
        flash[:success] = _('Admin|Tournament|Successfully toggled registration')
      else
        flash[:danger] = _('Admin|Tournament|Could not toggle registration')
      end

      redirect_to admin_tournament_path(model)
    end

    def disputed_matches
      add_breadcrumb _('Admin|Tournaments|Disputed matches')
      op Operations::Admin::Tournament::DisputedMatches
    end

    def permissions
      op Operations::Admin::Tournament::UpdatePermissions
      add_breadcrumb model.name, admin_tournament_path(model)
    end

    def update_permissions
      if run Operations::Admin::Tournament::UpdatePermissions
        flash[:success] = _('Admin|Tournament|Successfully updated permissions')
        redirect_to admin_tournament_path(model)
      else
        add_breadcrumb model.name, admin_tournament_path(model)
        flash[:danger] = _('Admin|Tournament|Failed to update the permissions')
        render :permissions, status: :unprocessable_entity
      end
    end
  end
end
