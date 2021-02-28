class User < ApplicationRecord
  has_secure_password validations: false
  has_secure_password :remember_me_token, validations: false
  has_secure_password :password_reset_token, validations: false

  RESET_TOKEN_EXPIRES_AFTER = 6.hours

  attr_writer :needs_password_set

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 10, maximum: 72 }, confirmation: true, if: -> { password.present? || new_record? || needs_password_set? }

  def username
    email
  end

  private

  def needs_password_set?
    @needs_password_set.is_a?(TrueClass)
  end
end
