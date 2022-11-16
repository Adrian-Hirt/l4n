module Admin
  class StartpageBannersController < AdminController
    add_breadcrumb _('Admin|StartpageBanners'), :admin_startpage_banners_path

    def index
      op Operations::Admin::StartpageBanner::Index
    end

    def new
      op Operations::Admin::StartpageBanner::Create
      add_breadcrumb _('Admin|StartpageBanner|New')
    end

    def create
      if run Operations::Admin::StartpageBanner::Create
        flash[:success] = _('Admin|StartpageBanner|Successfully created')
        redirect_to admin_startpage_banners_path
      else
        add_breadcrumb _('Admin|StartpageBanner|Edit')
        flash[:danger] = _('Admin|StartpageBanner|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::StartpageBanner::Update
      add_breadcrumb _('Admin|StartpageBanner|Edit')
    end

    def update
      if run Operations::Admin::StartpageBanner::Update
        flash[:success] = _('Admin|StartpageBanner|Successfully updated')
        redirect_to admin_startpage_banners_path
      else
        add_breadcrumb _('Admin|StartpageBanner|Edit')
        flash[:danger] = _('Admin|StartpageBanner|Edit failed')
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::StartpageBanner::Destroy
        flash[:success] = _('Admin|StartpageBanner|Successfully deleted')
      else
        flash[:danger] = _('Admin|StartpageBanner|Cannot be deleted')
      end
      redirect_to admin_startpage_banners_path
    end
  end
end
