class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_gettext_locale

  include SessionsHelper

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { head :forbidden }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  private

  def require_logged_in_user
    return if logged_in?

    flash[:danger] = _('Session|Please log in')
    redirect_to login_url
  end
end
