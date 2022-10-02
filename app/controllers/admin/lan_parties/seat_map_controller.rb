module Admin
  module LanParties
    class SeatMapController < AdminController
      add_breadcrumb _('Admin|LanParty'), :admin_lan_parties_path

      def show
        op Operations::Admin::SeatMap::LoadForLanParty
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|SeatMap')
      end

      def update
        if run Operations::Admin::SeatMap::Update
          flash[:success] = _('Admin|SeatMap|Updated successfully')
        else
          flash[:danger] = _('Admin|SeatMap|Edit failed')
        end

        redirect_to admin_lan_party_seat_map_path(model)
      end

      def update_seats
        if run Operations::Admin::SeatMap::UpdateSeats
          head :ok
        else
          flash[:danger] = _('Admin|SeatMap|Something went wrong, please try again')
          head :bad_request
        end
      rescue ActiveRecord::RecordNotDestroyed
        flash[:danger] = _('Admin|SeatMap|Cannot delete some of the seats you wanted to delete')
        head :bad_request
      end

      def seats
        op Operations::Admin::SeatMap::LoadSeats
        render json: op.data
      end
    end
  end
end
