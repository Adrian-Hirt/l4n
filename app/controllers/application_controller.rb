class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { head :forbidden }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  private

  def require_logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = _('Session|Please log in')
    redirect_to login_url
  end

  def redirect_back_or_root
    session.delete(:redirect_url)
    redirect_to(session[:redirect_url] || root_path)
  end

  def store_location
    session[:redirect_url] = request.original_url if request.get?
  end
end
