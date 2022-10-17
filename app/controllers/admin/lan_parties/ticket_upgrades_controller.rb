module Admin
  module LanParties
    class TicketUpgradesController < AdminController
      add_breadcrumb _('Admin|LanParty'), :admin_lan_parties_path

      def index
        op Operations::Admin::TicketUpgrade::LoadForLanParty
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|TicketUpgrades')
      end
    end
  end
end
