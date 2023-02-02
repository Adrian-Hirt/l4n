module Admin
  module LanParties
    class TicketsController < AdminController
      add_breadcrumb _('Admin|LanParty'), :admin_lan_parties_path

      def index
        op Operations::Admin::Ticket::LoadForLanParty
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|Tickets')
      end

      def show
        op Operations::Admin::Ticket::Load
        add_breadcrumb model.lan_party.name, admin_lan_party_path(model.lan_party)
        add_breadcrumb _('Admin|Tickets'), admin_lan_party_tickets_path(model.lan_party)
      end

      def new
        op Operations::Admin::Ticket::Create
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|Tickets'), admin_lan_party_tickets_path(op.lan_party)
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Ticket') }
      end

      def create
        if run Operations::Admin::Ticket::Create
          flash[:success] = _('Admin|%{model_name}|Successfully created') % { model_name: _('Ticket') }
          redirect_to admin_ticket_path(model)
        else
          add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
          add_breadcrumb _('Admin|Tickets'), admin_lan_party_tickets_path(op.lan_party)
          add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Ticket') }
          flash[:danger] = _('Admin|%{model_name}|Create failed') % { model_name: _('Ticket') }
          render :new, status: :unprocessable_entity
        end
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
        add_breadcrumb op.lan_party.name, admin_lan_party_path(op.lan_party)
        add_breadcrumb _('Admin|Tickets'), admin_lan_party_tickets_path(op.lan_party)
        add_breadcrumb _('Admin|%{model_name}|New') % { model_name: _('Ticket') }
        render :new, status: :unprocessable_entity
      end

      def assign_user
        if run Operations::Admin::Ticket::AssignToUser
          flash[:success] = _('Admin|Ticket|Successfully assigned user')
        else
          flash[:danger] = _('Admin|Ticket|User could not be assigned')
        end
        redirect_to admin_ticket_path(model)
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
        redirect_to admin_ticket_path(model)
      end

      def remove_assignee
        if run Operations::Admin::Ticket::RemoveAssignee
          flash[:success] = _('Admin|Ticket|Successfully removed assignee')
        else
          flash[:danger] = _('Admin|Ticket|Assignee could not be removed')
        end
        redirect_to admin_ticket_path(model)
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
        redirect_to admin_ticket_path(model)
      end

      def assign_seat
        if run Operations::Admin::Ticket::AssignSeat
          flash[:success] = _('Admin|Ticket|Successfully assigned seat')
        else
          flash[:danger] = _('Admin|Ticket|Seat could not be assigned')
        end
        redirect_to admin_ticket_path(model)
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
        redirect_to admin_ticket_path(model)
      end

      def remove_seat
        if run Operations::Admin::Ticket::RemoveSeat
          flash[:success] = _('Admin|Ticket|Successfully removed seat')
        else
          flash[:danger] = _('Admin|Ticket|Seat could not be removed')
        end
        redirect_to admin_ticket_path(model)
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
        redirect_to admin_ticket_path(model)
      end

      def check_in
        if run Operations::Admin::Ticket::CheckIn
          flash[:success] = _('Admin|Ticket|Successfully checked in')
        else
          flash[:danger] = _('Admin|Ticket|Could not check-in')
        end
        redirect_to admin_ticket_path(model)
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
        redirect_to admin_ticket_path(model)
      end

      def revert_check_in
        if run Operations::Admin::Ticket::RevertCheckIn
          flash[:success] = _('Admin|Ticket|Successfully reverted the check in')
        else
          flash[:danger] = _('Admin|Ticket|Could not check-in')
        end
        redirect_to admin_ticket_path(model)
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
        redirect_to admin_ticket_path(model)
      end

      def change_category
        if run Operations::Admin::Ticket::ChangeCategory
          flash[:success] = _('Admin|Ticket|Successfully changed the category')
        else
          flash[:danger] = _('Admin|Ticket|Category could not be changed')
        end
        redirect_to admin_ticket_path(model)
      rescue Operations::Exceptions::OpFailed => e
        flash[:danger] = e.message
        redirect_to admin_ticket_path(model)
      end
    end
  end
end
