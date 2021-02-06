class UserMailer < ApplicationMailer
  def confirm_signup
    @user = params[:user]

    mail to: "to@example.org"
  end
end
