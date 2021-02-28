class PasswordResetsController < ApplicationController
  def request_password_reset
    if request.post? && run(Operations::User::RequestPasswordReset)
      flash[:success] = _('PasswordResetRequest|If account exists, password reset mail was sent')
      redirect_to root_path
    end
  end

  def reset_password
    op Operations::User::ResetPassword
    if request.patch?
      if run
        flash[:success] = _('PasswordResetRequest|Password changed successfully')
        redirect_to root_path
      else
        flash[:danger] = _('PasswordResetRequest|Failed to change password')
        render 'reset_password'
      end
    end
  rescue Operations::User::ResetPasswordRequestInvalid
    flash[:danger] = _('PasswordResetRequest|Token invalid or expired')
    redirect_to root_path
  end
end
