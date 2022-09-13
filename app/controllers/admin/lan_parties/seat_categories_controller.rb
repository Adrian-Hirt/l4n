module Admin
  module LanParties
    class SeatCategoriesController < AdminController
      add_breadcrumb _('Admin|LanParty'), :admin_lan_parties_path

      def index
        op Operations::Admin::SeatCategory::Index
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|SeatCategory')
      end

      def new
        op Operations::Admin::SeatCategory::Create
        add_create_breadcrumbs
      end

      def create
        if run Operations::Admin::SeatCategory::Create
          flash[:success] = _('SeatCategory|Successfully created')
          redirect_to admin_lan_party_seat_categories_path(model.lan_party)
        else
          add_create_breadcrumbs
          flash[:danger] = _('SeatCategory|Create failed')
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        op Operations::Admin::SeatCategory::Update
        add_update_breadcrumbs
      end

      def update
        if run Operations::Admin::SeatCategory::Update
          flash[:success] = _('SeatCategory|Successfully updated')
          redirect_to admin_lan_party_seat_categories_path(model.lan_party)
        else
          add_update_breadcrumbs
          flash[:danger] = _('SeatCategory|Edit failed')
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if run Operations::Admin::SeatCategory::Destroy
          flash[:success] = _('SeatCategory|Successfully deleted')
        else
          flash[:danger] = _('SeatCategory|Cannot be deleted')
        end
        redirect_to admin_lan_party_seat_categories_path(model.lan_party)
      end

      private

      def add_create_breadcrumbs
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|SeatCategory'), admin_lan_party_seat_categories_path(op.lan_party)
        add_breadcrumb _('Admin|SeatCategory|New')
      end

      def add_update_breadcrumbs
        add_breadcrumb model.lan_party.name, admin_lan_party_path(model.lan_party)
        add_breadcrumb _('Admin|SeatCategory'), admin_lan_party_seat_categories_path(model.lan_party)
        add_breadcrumb model.name
      end
    end
  end
end
