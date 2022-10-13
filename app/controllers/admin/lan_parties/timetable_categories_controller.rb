module Admin
  module LanParties
    class TimetableCategoriesController < AdminController
      add_breadcrumb _('Admin|LanParty'), :admin_lan_parties_path

      def new
        op Operations::Admin::TimetableCategory::Create
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|Timetable'), admin_lan_party_timetable_path(op.lan_party)
      end

      def create
        if run Operations::Admin::TimetableCategory::Create
          flash[:success] = _('Admin|Timetable|Category successfully created')
          redirect_to admin_lan_party_timetable_path(op.lan_party)
        else
          flash[:danger] = _('Admin|Timetable|Category could not be created')
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        op Operations::Admin::TimetableCategory::Update
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|Timetable'), admin_lan_party_timetable_path(op.lan_party)
      end

      def update
        if run Operations::Admin::TimetableCategory::Update
          flash[:success] = _('Admin|Timetable|Category successfully updated')
          redirect_to admin_lan_party_timetable_path(op.lan_party)
        else
          flash[:danger] = _('Admin|Timetable|Category could not be updated')
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if run Operations::Admin::TimetableCategory::Destroy
          flash[:success] = _('Admin|Timetable|Category successfully deleted')
        else
          flash[:danger] = _('Admin|Timetable|Category could not be deleted')
        end

        redirect_to admin_lan_party_timetable_path(model.timetable.lan_party)
      end
    end
  end
end
