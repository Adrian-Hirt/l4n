class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_gettext_locale
  before_action :remove_tmp_login_hash

  include SessionsHelper
  include RailsOps::ControllerMixin

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.json { head :not_found }
      format.html { head :not_found }
      format.js   { head :not_found }
    end
  end

  def set_locale
    if FastGettext.default_available_locales.include?(params[:locale])
      requested_locale = params[:locale]
      locale = FastGettext.set_locale(requested_locale)
      session[:locale] = locale
      I18n.locale = locale
      current_user&.update(preferred_locale: locale)
      flash[:success] = _('Application|Language successfully changed')
    end
    redirect_back(fallback_location: root_path)
  end

  def toggle_dark_mode
    # Update dark mode preference of the user
    current_mode = current_user&.frontend_dark_mode || cookies[:_l4n_dark_mode].present? || false
    new_mode = !current_mode
    current_user&.update(frontend_dark_mode: new_mode)
    if new_mode
      cookies[:_l4n_dark_mode] = true
    else
      cookies.delete(:_l4n_dark_mode)
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def require_logged_in_user
    return if logged_in?

    flash[:danger] = _('Session|Please log in')
    redirect_to login_url
  end

  def set_gettext_locale
    requested_locale = current_user&.preferred_locale || session[:locale] || request.env['HTTP_ACCEPT_LANGUAGE'] || I18n.default_locale
    locale = FastGettext.set_locale(requested_locale)
    session[:locale] = locale
    I18n.locale = locale # some weird overwriting in action-controller makes this necessary ... see I18nProxy
  end

  def remove_tmp_login_hash
    session.delete(:tmp_login)
  end
end
