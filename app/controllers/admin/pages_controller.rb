module Admin
  class PagesController < AdminController
    add_breadcrumb _('Admin|Pages'), :admin_pages_path

    def index
      op Operations::Admin::Page::Index
    end

    def new_content_page
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Page') }
      op Operations::Admin::Page::CreateContentPage
    end

    def create_content_page
      if run Operations::Admin::Page::CreateContentPage
        flash[:success] = _('Admin|Page|Successfully created content page')
        redirect_to admin_pages_path
      else
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Page') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('Page') }
        render :new_content_page, status: :unprocessable_entity
      end
    end

    def new_redirect_page
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Page') }
      op Operations::Admin::Page::CreateRedirectPage
    end

    def create_redirect_page
      if run Operations::Admin::Page::CreateRedirectPage
        flash[:success] = _('Admin|Page|Successfully created redirect page')
        redirect_to admin_pages_path
      else
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Page') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('Page') }
        render :new_redirect_page, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::Page::Update
      add_breadcrumb model.title
    end

    def update
      if run Operations::Admin::Page::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('Page') }
        redirect_to admin_pages_path
      else
        add_breadcrumb model.title
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('Page') }
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::Page::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('Page') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('Page') }
      end
      redirect_to admin_pages_path
    end
  end
end
