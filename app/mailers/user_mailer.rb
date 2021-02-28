class UserMailer < ApplicationMailer
  def confirm_signup
    @user = params[:user]

    mail(
      to:      @user.email,
      subject: _('UserMailer|ConfirmSignup|Confirm your account')
    )
  end
end
