class TicketScannerController < ApplicationController
  layout 'scanner'
  before_action :authenticate_scanner_user!
  skip_forgery_protection

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

  private

  def op_context
    @op_context ||= begin
      context = RailsOps::Context.new
      context.user = current_scanner_user if defined?(current_scanner_user)
      context.ability = ScannerAbility.new(current_scanner_user)
      context.session = session
      context.url_options = url_options
      context.view = view_context
      context
    end
  end
end
