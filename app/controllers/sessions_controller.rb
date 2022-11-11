class SessionsController < Devise::SessionsController
  prepend_before_action :authenticate_with_otp_two_factor, if: -> { action_name == 'create' && otp_two_factor_enabled? }
  protect_from_forgery with: :exception, prepend: true, except: :destroy
  skip_before_action :require_no_authentication, only: %i[new]

  def new
    if user_signed_in?
      flash[:danger] = _('Session|Already logged in')
      redirect_to root_path
      return
    end

    session[:otp_user_id] = nil
    super
  end

  # Wrong flash message...
  def create
    super

    flash.delete :notice
    flash[:success] = _('Session|Successfully logged in')
  end

  def authenticate_with_otp_two_factor
    user = self.resource = find_user

    if user_params.key?(:otp_attempt) && session[:otp_user_id] && session[:otp_user_id_set_at] > 5.minutes.ago
      authenticate_user_with_otp_two_factor(user)
    elsif user&.valid_password?(user_params[:password])
      session[:remember_me] = user_params[:remember_me]
      prompt_for_otp_two_factor(user)
    end
  end

  def set_flash_message(key, kind, options = {})
    return if kind == 'already_authenticated'

    super
  end

  def destroy
    super

    flash[:success] = _('Session|Successfully logged out')
  end

  private

  def valid_otp_attempt?(user)
    user.validate_and_consume_otp!(user_params[:otp_attempt]) || invalidate_otp_backup_code!(user, user_params[:otp_attempt])
  end

  def prompt_for_otp_two_factor(user)
    @user = user

    session[:otp_user_id] = user.id
    session[:otp_user_id_set_at] = Time.zone.now

    render 'devise/sessions/two_factor'
  end

  def authenticate_user_with_otp_two_factor(user)
    if valid_otp_attempt?(user)
      # Remove any lingering user data from login
      session.delete(:otp_user_id)

      user.remember_me = true if session[:remember_me] == '1'
      sign_in(user, event: :authentication)
      flash[:success] = _('Session|Successfully logged in')
    else
      flash.now[:danger] = _('TwoFactor|Invalid two factor code')
      prompt_for_otp_two_factor(user)
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :remember_me, :otp_attempt)
  end

  def find_user
    if session[:otp_user_id] && session[:otp_user_id_set_at] > 5.minutes.ago
      ::User.find(session[:otp_user_id])
    elsif user_params[:email]
      session[:otp_user_id] = nil
      ::User.find_by(email: user_params[:email])
    end
  end

  def otp_two_factor_enabled?
    find_user&.otp_required_for_login
  end
end
