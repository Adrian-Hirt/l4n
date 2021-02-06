class UserMailer < ApplicationMailer
  def confirm_signup
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
