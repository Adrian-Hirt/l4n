module Admin
  class NewsPostsController < AdminController
    add_breadcrumb _('Admin|NewsPosts'), :admin_news_posts_path

    def index
      op Operations::Admin::NewsPost::Index
    end

    def new
      add_breadcrumb _('Admin|NewsPost|New')
      op Operations::Admin::NewsPost::Create
    end

    def create
      if run Operations::Admin::NewsPost::Create
        flash[:success] = _('Admin|NewsPost|Successfully created')
        redirect_to admin_news_posts_path
      else
        add_breadcrumb _('Admin|NewsPost|New')
        flash[:danger] = _('Admin|NewsPost|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::NewsPost::Update
      add_breadcrumb model.title
    end

    def update
      if run Operations::Admin::NewsPost::Update
        flash[:success] = _('Admin|NewsPost|Successfully updated')
        redirect_to admin_news_posts_path
      else
        add_breadcrumb model.title
        flash[:danger] = _('Admin|NewsPost|Edit failed')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::NewsPost::Destroy
        flash[:success] = _('Admin|NewsPost|Successfully deleted')
      else
        flash[:danger] = _('Admin|NewsPost|Cannot be deleted')
      end
      redirect_to admin_news_posts_path
    end
  end
end
