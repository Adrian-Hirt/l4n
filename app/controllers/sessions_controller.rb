class SessionsController < ApplicationController
  layout 'login_register'
  skip_before_action :remove_tmp_login_hash

  def new; end

  def create
    # Check if password is correct
    auth_op = Operations::SessionHandler::AuthenticateUser.new(op_params.slice(:login))
    if auth_op.run
      remember_me = ActiveModel::Type::Boolean.new.cast(op_params.dig(:login, :remember_me))
      if auth_op.user.two_factor_enabled?
        # if 2FA is enabled, store user in session and redirect to 2FA path
        session[:tmp_login] = {}
        session[:tmp_login][:user_id] = auth_op.user.id
        session[:tmp_login][:remember_me] = remember_me
        session[:tmp_login][:timestamp] = Time.zone.now
        redirect_to login_two_factor_path
      else
        # else, log in directly
        continue_login(auth_op.user, remember_me)
      end
    else
      # if not, re-render form
      flash[:danger] = _('Session|Login failed')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    run Operations::SessionHandler::UserLogout, user: current_user
    flash[:success] = _('Session|Successful logout')
    redirect_to root_path
  end

  def two_factor
    if session[:tmp_login].nil?
      flash[:danger] = _('Session|You first need to enter your password')
      redirect_to login_path
      return
    end

    # Check if the session already expired
    if session[:tmp_login][:timestamp] < 5.minutes.ago
      session.delete(:tmp_login)
      flash[:danger] = _('Session|Your login expired')
      redirect_to login_path
      return
    end

    return unless request.post?

    two_factor_op = Operations::SessionHandler::AuthenticateTwoFactor.new(op_context, op_params)
    if two_factor_op.run
      continue_login(two_factor_op.user, two_factor_op.remember_me)
    else
      flash.now[:danger] = _('Session|Login failed')
    end
  end

  private

  def continue_login(user, remember_me)
    run Operations::SessionHandler::CreateSession, user: user, remember_me: remember_me
    flash[:success] = _('Session|Successful login')
    redirect_to root_path
  end
end
