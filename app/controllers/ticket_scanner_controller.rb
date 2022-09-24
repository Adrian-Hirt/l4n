class TicketScannerController < ApplicationController
  layout 'scanner'
  before_action :authenticate_scanner_user!

  def scanner; end

  def info
    run Operations::TicketScanner::GetTicketInfo
    respond_to :turbo_stream
  rescue Operations::Exceptions::OpFailed => e
    flash[:danger] = e.message
    respond_to :turbo_stream
  end

  def checkin
    if run Operations::TicketScanner::CheckTicketIn
      flash[:success] = _('TicketScanner|Successfully checked in')
    else
      flash[:danger] = _('TicketScanner|Error checking in, please try again')
    end
    redirect_to ticket_scanner_path
  rescue Operations::Exceptions::OpFailed => e
    flash[:danger] = e.message
    redirect_to ticket_scanner_path
  end
end
