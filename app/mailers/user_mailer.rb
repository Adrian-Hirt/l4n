class UserMailer < ApplicationMailer
  def confirm_signup
    @user = params[:user]

    mail(
      to:      @user.email,
      subject: _('UserMailer|ConfirmSignup|Confirm your account')
    )
  end

  def password_reset_request
    @user = params[:user]
    @token = params[:reset_token]

    mail(
      to:      @user.email,
      subject: _('UserMailer|PasswordResetRequest|You resetted your password')
    )
  end
end
