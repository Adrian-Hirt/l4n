class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:login][:email])
    if user && user.activated? && user.authenticate(params[:login][:password])
      clean_cookies
      reset_session
      session[:user_id] = user.id
      if params[:login][:remember_me] == '1'
        remember_me_token = SecureRandom.urlsafe_base64(32)
        user.update(remember_me_token: remember_me_token)
        cookies.permanent.encrypted[:user_id] = {
          value:     user.id,
          same_site: :lax,
          http_only: true
        }
        cookies.permanent[:remember_token] = {
          value:     remember_me_token,
          same_site: :lax,
          http_only: true
        }
      else
        user.update(remember_me_token: nil)
      end
      flash[:success] = _('Session|Successful login')
      redirect_to root_path
    else
      flash.now[:danger] = _('Session|Login failed')
      render :new
    end
  end

  def destroy
    current_user.update(remember_me_token: nil)
    clean_cookies
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def clean_cookies
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
