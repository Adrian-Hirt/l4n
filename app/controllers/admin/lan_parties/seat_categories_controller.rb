module Admin
  module LanParties
    class SeatCategoriesController < AdminController
      add_breadcrumb _('Admin|LanParty'), :admin_lan_parties_path

      def index
        op Operations::Admin::SeatCategory::Index
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|SeatCategories')
      end

      def new
        op Operations::Admin::SeatCategory::Create
        add_create_breadcrumbs
      end

      def create
        if run Operations::Admin::SeatCategory::Create
          flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('SeatCategory') }
          redirect_to admin_lan_party_seat_categories_path(model.lan_party)
        else
          add_create_breadcrumbs
          flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('SeatCategory') }
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        op Operations::Admin::SeatCategory::Update
        add_update_breadcrumbs
      end

      def update
        if run Operations::Admin::SeatCategory::Update
          flash[:success] = _('Admin|%{model_name}|Successfully updated') % { model_name: _('SeatCategory') }
          redirect_to admin_lan_party_seat_categories_path(model.lan_party)
        else
          add_update_breadcrumbs
          flash[:danger] = _('Admin|%{model_name}|Update failed') % { model_name: _('SeatCategory') }
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if run Operations::Admin::SeatCategory::Destroy
          flash[:success] = _('Admin|%{model_name}|Successfully deleted') % { model_name: _('SeatCategory') }
        else
          flash[:danger] = _('Admin|%{model_name}|Cannot be deleted') % { model_name: _('SeatCategory') }
        end
        redirect_to admin_lan_party_seat_categories_path(model.lan_party)
      end

      private

      def add_create_breadcrumbs
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|SeatCategories'), admin_lan_party_seat_categories_path(op.lan_party)
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('SeatCategory') }
      end

      def add_update_breadcrumbs
        add_breadcrumb model.lan_party.name, admin_lan_party_path(model.lan_party)
        add_breadcrumb _('Admin|SeatCategories'), admin_lan_party_seat_categories_path(model.lan_party)
        add_breadcrumb model.name
      end
    end
  end
end
