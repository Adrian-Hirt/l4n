module Admin
  module LanParties
    class TicketsController < AdminController
      add_breadcrumb _('Admin|LanParty'), :admin_lan_parties_path

      def index
        op Operations::Admin::Ticket::LoadForLanParty
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|Tickets')
      end
    end
  end
end
