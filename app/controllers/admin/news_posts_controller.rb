module Admin
  class NewsPostsController < AdminController
    add_breadcrumb _('Admin|NewsPosts'), :admin_news_posts_path

    def index
      op Operations::Admin::NewsPost::Index
    end

    def new
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('NewsPost') }
      op Operations::Admin::NewsPost::Create
    end

    def create
      if run Operations::Admin::NewsPost::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('NewsPost') }
        redirect_to admin_news_posts_path
      else
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('NewsPost') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('NewsPost') }
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::NewsPost::Update
      add_breadcrumb model.title
    end

    def update
      if run Operations::Admin::NewsPost::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('NewsPost') }
        redirect_to admin_news_posts_path
      else
        add_breadcrumb model.title
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('NewsPost') }
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::NewsPost::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('NewsPost') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('NewsPost') }
      end
      redirect_to admin_news_posts_path
    end
  end
end
