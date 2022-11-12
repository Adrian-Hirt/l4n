module Admin
  class FooterLogosController < AdminController
    add_breadcrumb _('Admin|FooterLogos'), :admin_footer_logos_path

    def index
      op Operations::Admin::FooterLogo::Index
    end

    def new
      op Operations::Admin::FooterLogo::Create
      add_breadcrumb _('Admin|FooterLogo|New')
    end

    def create
      if run Operations::Admin::FooterLogo::Create
        flash[:success] = _('Admin|FooterLogo|Successfully created')
        redirect_to admin_footer_logos_path
      else
        add_breadcrumb _('Admin|FooterLogo|Edit')
        flash[:danger] = _('Admin|FooterLogo|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::FooterLogo::Update
      add_breadcrumb _('Admin|FooterLogo|Edit')
    end

    def update
      if run Operations::Admin::FooterLogo::Update
        flash[:success] = _('Admin|FooterLogo|Successfully updated')
        redirect_to admin_footer_logos_path
      else
        add_breadcrumb _('Admin|FooterLogo|Edit')
        flash[:danger] = _('Admin|FooterLogo|Edit failed')
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::FooterLogo::Destroy
        flash[:success] = _('Admin|FooterLogo|Successfully deleted')
      else
        flash[:danger] = _('Admin|FooterLogo|Cannot be deleted')
      end
      redirect_to admin_footer_logos_path
    end
  end
end
