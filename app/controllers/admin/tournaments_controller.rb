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
      add_breadcrumb model.name
    end

    def update
      if run Operations::Admin::Tournament::Update
        flash[:success] = _('Admin|Tournament|Successfully updated')
        redirect_to admin_tournament_path(model)
      else
        add_breadcrumb model.name
        flash[:danger] = _('Admin|Tournament|Update failed')
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      # TODO: Make sure tournaments are in a deletable state & all dependent
      # models get cleaned up properly
      fail NotImplementedError
      # if run Operations::Admin::Tournament::Destroy
      #   # handle successful case
      # else
      #   # handle error case
      # end
    end
  end
end
