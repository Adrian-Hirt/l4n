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
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Event') }
      op Operations::Admin::Event::Create
    end

    def create
      if run Operations::Admin::Event::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('Event') }
        redirect_to admin_events_path
      else
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Event') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('Event') }
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::Event::Update
      add_breadcrumb model.title
    end

    def update
      if run Operations::Admin::Event::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('Event') }
        redirect_to admin_events_path
      else
        add_breadcrumb model.title
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('Event') }
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::Event::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('Event') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('Event') }
      end
      redirect_to admin_events_path
    end
  end
end
