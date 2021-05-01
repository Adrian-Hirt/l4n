class SessionsController < ApplicationController
  layout 'login_register'

  def new; end

  def create
    if run Operations::SessionHandler::UserLogin
      flash[:success] = _('Session|Successful login')
      redirect_to root_path
    else
      flash.now[:danger] = _('Session|Login failed')
      render :new
    end
  end

  def destroy
    run Operations::SessionHandler::UserLogout, user: current_user
    flash[:success] = _('Session|Successful logout')
    redirect_to root_path
  end
end
