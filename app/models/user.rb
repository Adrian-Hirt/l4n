class User < ApplicationRecord
  has_secure_password validations: false
  has_secure_password :remember_me_token, validations: false

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 10, maximum: 72 }, confirmation: true, if: -> { password.present? || new_record? }

  def username
    email
  end
end
