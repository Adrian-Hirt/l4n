module Admin
  class FooterLogosController < AdminController
    add_breadcrumb _('Admin|FooterLogos'), :admin_footer_logos_path

    def index
      op Operations::Admin::FooterLogo::Index
    end

    def new
      op Operations::Admin::FooterLogo::Create
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('FooterLogo') }
    end

    def create
      if run Operations::Admin::FooterLogo::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('FooterLogo') }
        redirect_to admin_footer_logos_path
      else
        add_breadcrumb _('Admin|FooterLogo|Edit')
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('FooterLogo') }
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::FooterLogo::Update
      add_breadcrumb _('Admin|FooterLogo|Edit')
    end

    def update
      if run Operations::Admin::FooterLogo::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('FooterLogo') }
        redirect_to admin_footer_logos_path
      else
        add_breadcrumb _('Admin|FooterLogo|Edit')
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('FooterLogo') }
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::FooterLogo::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('FooterLogo') }
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('FooterLogo') }
      end
      redirect_to admin_footer_logos_path
    end
  end
end
