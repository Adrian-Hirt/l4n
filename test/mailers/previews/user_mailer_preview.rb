# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/confirm_signup
  def confirm_signup
    UserMailer.with(user: User.first).confirm_signup
  end

end
