module Admin
  module LanParties
    class TimetableEntriesController < AdminController
      add_breadcrumb _('Admin|LanParty'), :admin_lan_parties_path

      def new
        op Operations::Admin::TimetableEntry::Create
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|Timetable'), admin_lan_party_timetable_path(op.lan_party)
      end

      def create
        if run Operations::Admin::TimetableEntry::Create
          flash[:success] = _('Admin|Timetable|Entry successfully created')
          redirect_to admin_lan_party_timetable_path(op.lan_party)
        else
          add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
          add_breadcrumb _('Admin|Timetable'), admin_lan_party_timetable_path(op.lan_party)
          flash[:danger] = _('Admin|Timetable|Entry could not be created')
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        op Operations::Admin::TimetableEntry::Update
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|Timetable'), admin_lan_party_timetable_path(op.lan_party)
      end

      def update
        if run Operations::Admin::TimetableEntry::Update
          flash[:success] = _('Admin|Timetable|Entry successfully updated')
          redirect_to admin_lan_party_timetable_path(op.lan_party)
        else
          add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
          add_breadcrumb _('Admin|Timetable'), admin_lan_party_timetable_path(op.lan_party)
          flash[:danger] = _('Admin|Timetable|Entry could not be updated')
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if run Operations::Admin::TimetableEntry::Destroy
          flash[:success] = _('Admin|Timetable|Entry successfully deleted')
        else
          flash[:danger] = _('Admin|Timetable|Entry could not be deleted')
        end

        redirect_to admin_lan_party_timetable_path(model.timetable_category.timetable.lan_party)
      end
    end
  end
end
