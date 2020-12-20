class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:login][:email])
    if user&.authenticate(params[:login][:password])
      reset_session
      session[:user_id] = user.id
      flash[:success] = _('Session|Successful login')
      redirect_to root_path
    else
      flash.now[:danger] = _('Session|Login failed')
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
