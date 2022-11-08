class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_gettext_locale, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  include RailsOps::ControllerMixin

  # Fail with a 404 as we don't want to expose possible existing,
  # but not accessible entities. However, we skip this in development
  # environment.
  unless Rails.env.development?
    rescue_from CanCan::AccessDenied do |_exception|
      fail ActiveRecord::RecordNotFound
    end
  end

  def toggle_dark_mode
    # Update dark mode preference of the user
    current_mode = current_user&.use_dark_mode || cookies[:_l4n_dark_mode].present? || false
    new_mode = !current_mode
    current_user&.update(use_dark_mode: new_mode)
    if new_mode
      cookies[:_l4n_dark_mode] = true
      flash[:success] = _('Application|Dark mode successfully enabled')
    else
      cookies.delete(:_l4n_dark_mode)
      flash[:success] = _('Application|Dark mode successfully disabled')
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def set_gettext_locale
    requested_locale = session[:locale] || request.env['HTTP_ACCEPT_LANGUAGE'] || I18n.default_locale
    locale = FastGettext.set_locale(requested_locale)
    session[:locale] = locale
    I18n.locale = locale # some weird overwriting in action-controller makes this necessary ... see I18nProxy
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email otp_attempt password])
  end

  # Enables the sidebar layout for that controller if the feature flag is toggled on
  def enable_sidebar_layout
    @use_sidebar_layout = FeatureFlag.enabled?(:frontend_sidebar)
  end
end
