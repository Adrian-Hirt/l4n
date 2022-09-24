class ScannerUserSessionsController < Devise::SessionsController
  protect_from_forgery with: :exception, prepend: true, except: :destroy
  skip_before_action :require_no_authentication, only: %i[new]

  def new
    if scanner_user_signed_in?
      flash[:danger] = _('ScannerUser|Already logged in')
      redirect_to ticket_scanner_path
      return
    end

    super
  end

  def destroy
    super

    flash[:success] = _('ScannerUser|Successfully logged out')
  end

  private

  def set_flash_message(key, kind, options = {})
    message = find_message(kind, options)

    if key == :notice
      key = :success
    else
      key = :danger
    end

    if options[:now]
      flash.now[key] = message if message.present?
    else
      flash[key] = message if message.present?
    end
  end
end
