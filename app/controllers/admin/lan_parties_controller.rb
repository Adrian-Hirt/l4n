module Admin
  class LanPartiesController < AdminController
    add_breadcrumb _('Admin|LanParty'), :admin_lan_parties_path

    def index
      op Operations::Admin::LanParty::Index
    end

    def show
      op Operations::Admin::LanParty::Load
      add_breadcrumb model.name
    end

    def new
      op Operations::Admin::LanParty::Create
      add_breadcrumb _('Admin|LanParty|New')
    end

    def create
      if run Operations::Admin::LanParty::Create
        flash[:success] = _('LanParty|Successfully created')
        redirect_to admin_lan_parties_path
      else
        add_breadcrumb _('Admin|LanParty|New')
        flash[:danger] = _('LanParty|Create failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::LanParty::Update
      add_breadcrumb model.name
    end

    def update
      if run Operations::Admin::LanParty::Update
        flash[:success] = _('LanParty|Successfully updated')
        redirect_to admin_lan_parties_path
      else
        add_breadcrumb model.name
        flash[:danger] = _('LanParty|Edit failed')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::LanParty::Destroy
        flash[:success] = _('LanParty|Successfully deleted')
        redirect_to admin_lan_parties_path
      else
        flash[:danger] = _('LanParty|Cannot be deleted')
        redirect_to admin_lan_party_path(model)
      end
    rescue ActiveRecord::RecordNotDestroyed
      flash[:danger] = _('LanParty|Cannot be deleted')
      redirect_to admin_lan_party_path(model)
    end
  end
end
