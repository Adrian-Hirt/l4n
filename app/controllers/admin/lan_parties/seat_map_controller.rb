module Admin
  module LanParties
    class SeatMapController < AdminController
      add_breadcrumb _('Admin|LanParty'), :admin_lan_parties_path

      def show
        op Operations::Admin::SeatMap::LoadForLanParty
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|SeatMap')
      end

      def update_seats
        run Operations::Admin::SeatMap::UpdateSeats
        head :ok
      end

      def seats
        op Operations::Admin::SeatMap::LoadSeats
        render json: op.data
      end
    end
  end
end
