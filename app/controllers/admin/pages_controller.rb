module Admin
  class PagesController < AdminController
    add_breadcrumb _('Admin|Pages'), :admin_pages_path

    def index
      op Operations::Admin::Pages::Index
    end

    def new
      add_breadcrumb _('Admin|Page|New')
      op Operations::Admin::Pages::Create
    end

    def create
      if run Operations::Admin::Pages::Create
        flash[:success] = _('Admin|Page|Successfully created')
        redirect_to admin_pages_path
      else
        add_breadcrumb _('Admin|Page|New')
        flash[:danger] = _('Admin|Page|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::Pages::Update
      add_breadcrumb model.title
    end

    def update
      if run Operations::Admin::Pages::Update
        flash[:success] = _('Admin|Page|Successfully updated')
        redirect_to admin_pages_path
      else
        add_breadcrumb model.title
        flash[:danger] = _('Admin|Page|Edit failed')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::Pages::Destroy
        flash[:success] = _('Admin|Page|Successfully deleted')
      else
        flash[:danger] = _('Admin|Page|Cannot be deleted')
      end
      redirect_to admin_pages_path
    end
  end
end
