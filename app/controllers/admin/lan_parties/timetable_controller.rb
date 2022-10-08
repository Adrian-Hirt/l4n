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
      end

      def update
        if run Operations::Admin::Timetable::Update
          flash[:success] = _('Admin|Timetable|Successfully updated')
          redirect_to admin_lan_party_timetable_path(model)
        else
          flash[:danger] = _('Admin|Timetable|Could not be updated')
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end
end