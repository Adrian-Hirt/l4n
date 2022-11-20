module Admin
  module LanParties
    class TimetableController < AdminController
      add_breadcrumb _('Admin|LanParty'), :admin_lan_parties_path

      def show
        op Operations::Admin::Timetable::LoadForLanParty
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|Timetable')
      end

      def edit
        op Operations::Admin::Timetable::Update
        add_breadcrumb model.lan_party.name, admin_lan_party_path(model.lan_party)
        add_breadcrumb _('Admin|Timetable')
      end

      def update
        if run Operations::Admin::Timetable::Update
          flash[:success] = _('Admin|%{model_name}|Create failed') % { model_name: _('Timetable') }
          redirect_to admin_lan_party_timetable_path(model)
        else
          add_breadcrumb model.lan_party.name, admin_lan_party_path(model.lan_party)
          add_breadcrumb _('Admin|Timetable')
          flash[:danger] = _('Admin|Timetable|Could not be updated')
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end
end
