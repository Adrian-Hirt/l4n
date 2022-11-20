module Admin
  class LanPartiesController < AdminController
    add_breadcrumb _('Admin|LanParties'), :admin_lan_parties_path

    def index
      op Operations::Admin::LanParty::Index
    end

    def show
      op Operations::Admin::LanParty::Load
      add_breadcrumb model.name
    end

    def new
      op Operations::Admin::LanParty::Create
      add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('LanParty') }
    end

    def create
      if run Operations::Admin::LanParty::Create
        flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('LanParty') }
        redirect_to admin_lan_party_path(model)
      else
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('LanParty') }
        flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('LanParty') }
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      op Operations::Admin::LanParty::Update
      add_breadcrumb model.name
    end

    def update
      if run Operations::Admin::LanParty::Update
        flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('LanParty') }
        redirect_to admin_lan_party_path(model)
      else
        add_breadcrumb model.name
        flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('LanParty') }
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if run Operations::Admin::LanParty::Destroy
        flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('LanParty') }
        redirect_to admin_lan_parties_path
      else
        flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('LanParty') }
        redirect_to admin_lan_party_path(model)
      end
    rescue ActiveRecord::RecordNotDestroyed
      flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('LanParty') }
      redirect_to admin_lan_party_path(model)
    end

    def export_seat_assignees
      op Operations::Admin::LanParty::ExportSeatAssignees

      respond_to do |format|
        format.json { send_data op.json_data }
        format.csv { send_data op.csv_data }
      end
    end
  end
end
