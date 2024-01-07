module Admin
  class StartpageBannersController < AdminController
    add_breadcrumb _('Admin|StartpageBanners'), :admin_startpage_banners_path

    def index
      op Operations::Admin::StartpageBanner::Index
    end

    def new
      op Operations::Admin::StartpageBanner::Create
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('StartpageBanner') }
    end

    def create
      if run Operations::Admin::StartpageBanner::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('StartpageBanner') }
        redirect_to admin_startpage_banner_path(model)
      else
        add_breadcrumb _('Admin|%{model_name}|Edit') % { model_name: _('StartpageBanner') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('StartpageBanner') }
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::StartpageBanner::Update
      add_breadcrumb _('Admin|%{model_name}|Edit') % { model_name: _('StartpageBanner') }
    end

    def update
      if run Operations::Admin::StartpageBanner::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('StartpageBanner') }
        redirect_to admin_startpage_banner_path(model)
      else
        add_breadcrumb _('Admin|%{model_name}|Edit') % { model_name: _('StartpageBanner') }
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('StartpageBanner') }
        render :update, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::StartpageBanner::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('StartpageBanner') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('StartpageBanner') }
      end
      redirect_to admin_startpage_banners_path
    end
  end
end
