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
      add_breadcrumb _('Admin|Tournament|New')
    end

    def create
      if run Operations::Admin::Tournament::Create
        flash[:success] = _('Admin|Tournament|Successfully created')
        redirect_to admin_tournament_path(model)
      else
        add_breadcrumb _('Admin|Tournament|New')
        flash[:danger] = _('Admin|Tournament|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::Tournament::Update
      add_breadcrumb model.name, admin_tournament_path(model)
    end

    def update
      if run Operations::Admin::Tournament::Update
        flash[:success] = _('Admin|Tournament|Successfully updated')
        redirect_to admin_tournament_path(model)
      else
        add_breadcrumb model.name, admin_tournament_path(model)
        flash[:danger] = _('Admin|Tournament|Update failed')
        render :new, status: :unprocessable_entity
      end
    end

    def toggle_registration
      if run Operations::Admin::Tournament::ToggleRegistration
        flash[:success] = _('Admin|Tournament|Successfully toggled registration')
      else
        flash[:danger] = _('Admin|Tournament|Could not toggle registration')
      end

      redirect_to admin_tournament_path(model)
    end
  end
end
