module Lan
  class TicketsController < LanController
    def assign
      if run Operations::Ticket::AssignToUser
        flash[:success] = _('Ticket|Successfully assigned')
      else
        flash[:danger] = _('Ticket|Could not be assigned')
      end

      respond_to :turbo_stream
    rescue Operations::Exceptions::OpFailed => e
      flash[:danger] = e.message
      respond_to :turbo_stream
    end

    def remove_assignee
      if run Operations::Ticket::RemoveAssignee
        flash[:success] = _('Ticket|Successfully removed assignee')
      else
        flash[:danger] = _('Ticket|Assignee could not be removed')
      end

      respond_to :turbo_stream
    rescue Operations::Exceptions::OpFailed => e
      flash[:danger] = e.message
      respond_to :turbo_stream
    end

    def take_seat
      if run Operations::Ticket::TakeSeat
        flash[:success] = _('Ticket|Successfully taken seat')
      else
        flash[:danger] = _('Ticket|Seat could not be taken')
      end

      respond_to :turbo_stream
    rescue Operations::Exceptions::OpFailed => e
      flash[:danger] = e.message
      respond_to :turbo_stream
    end

    def remove_seat
      if run Operations::Ticket::RemoveSeat
        flash[:success] = _('Ticket|Successfully removed seat')
      else
        flash[:danger] = _('Ticket|Seat could not be removed')
      end

      respond_to :turbo_stream
    rescue Operations::Exceptions::OpFailed => e
      flash[:danger] = e.message
      respond_to :turbo_stream
    end

    def my_ticket
      op Operations::Ticket::LoadMyTicket
    rescue Operations::Exceptions::OpFailed => e
      flash[:danger] = e.message
      redirect_to lan_seatmap_path
    end

    def manage
      op Operations::Ticket::Manage
    rescue Operations::Exceptions::OpFailed => e
      flash[:danger] = e.message
      redirect_to lan_seatmap_path
    end

    def apply_upgrade
      if run Operations::TicketUpgrade::Apply
        flash[:success] = _('TicketUpgrade|Applied successfully')
      else
        flash[:danger] = _('TicketUpgrade|Could not be applied')
      end

      redirect_to manage_lan_tickets_path
    rescue Operations::Exceptions::OpFailed => e
      flash[:danger] = e.message
      redirect_to manage_lan_tickets_path
    end
  end
end
