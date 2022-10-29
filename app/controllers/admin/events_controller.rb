module Admin
  class EventsController < AdminController
    add_breadcrumb _('Admin|Events'), :admin_events_path

    def index
      op Operations::Admin::Event::Index
    end

    def archive
      add_breadcrumb _('Admin|Events|Archive')
      op Operations::Admin::Event::Archive
    end

    def new
      add_breadcrumb _('Admin|Event|New')
      op Operations::Admin::Event::Create
    end

    def create
      if run Operations::Admin::Event::Create
        flash[:success] = _('Admin|Event|Successfully created')
        redirect_to admin_events_path
      else
        add_breadcrumb _('Admin|Event|New')
        flash[:danger] = _('Admin|Event|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::Event::Update
      add_breadcrumb model.title
    end

    def update
      if run Operations::Admin::Event::Update
        flash[:success] = _('Admin|Event|Successfully updated')
        redirect_to admin_events_path
      else
        add_breadcrumb model.title
        flash[:danger] = _('Admin|Event|Edit failed')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::Event::Destroy
        flash[:success] = _('Admin|Event|Successfully deleted')
      else
        flash[:danger] = _('Admin|Event|Cannot be deleted')
      end
      redirect_to admin_events_path
    end
  end
end
