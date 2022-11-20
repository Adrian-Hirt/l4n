module Admin
  class PagesController < AdminController
    add_breadcrumb _('Admin|Pages'), :admin_pages_path

    def index
      op Operations::Admin::Page::Index
    end

    def new_content_page
      add_breadcrumb _('Admin|Page|New')
      op Operations::Admin::Page::CreateContentPage
    end

    def create_content_page
      if run Operations::Admin::Page::CreateContentPage
        flash[:success] = _('Admin|Page|Successfully created content page')
        redirect_to admin_pages_path
      else
        add_breadcrumb _('Admin|Page|New')
        flash[:danger] = _('Admin|Page|Create failed')
        render :new_content_page, status: :unprocessable_entity
      end
    end

    def new_redirect_page
      add_breadcrumb _('Admin|Page|New')
      op Operations::Admin::Page::CreateRedirectPage
    end

    def create_redirect_page
      if run Operations::Admin::Page::CreateRedirectPage
        flash[:success] = _('Admin|Page|Successfully created redirect page')
        redirect_to admin_pages_path
      else
        add_breadcrumb _('Admin|Page|New')
        flash[:danger] = _('Admin|Page|Create failed')
        render :new_redirect_page, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::Page::Update
      add_breadcrumb model.title
    end

    def update
      if run Operations::Admin::Page::Update
        flash[:success] = _('Admin|Page|Successfully updated')
        redirect_to admin_pages_path
      else
        add_breadcrumb model.title
        flash[:danger] = _('Admin|Page|Edit failed')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::Page::Destroy
        flash[:success] = _('Admin|Page|Successfully deleted')
      else
        flash[:danger] = _('Admin|Page|Cannot be deleted')
      end
      redirect_to admin_pages_path
    end
  end
end
