module Admin
  module LanParties
    class TimetableController < AdminController
      add_breadcrumb _('Admin|LanParty'), :admin_lan_parties_path

      def show
        op Operations::Admin::Timetable::LoadForLanParty
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|Timetable')
      end
    end
  end
end
