# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/confirm_signup
  def confirm_signup
    UserMailer.with(user: User.first).confirm_signup
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset_request
  def password_reset_request
    token = SecureRandom.urlsafe_base64(64)
    UserMailer.with(user: User.first, reset_token: token).password_reset_request
  end
end
