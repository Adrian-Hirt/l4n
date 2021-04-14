class User < ApplicationRecord
  has_secure_password validations: false
  has_secure_password :remember_me_token, validations: false
  has_secure_password :password_reset_token, validations: false

  # Avatar image
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize: '100x100'
    attachable.variant :medium, resize: '300x300'
  end

  RESET_TOKEN_EXPIRES_AFTER = 6.hours

  attr_writer :needs_password_set

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 10, maximum: 72 }, confirmation: true, if: -> { password.present? || new_record? || needs_password_set? }
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  def thumb_avatar
    avatar.variant(resize_to_fill: [100, 100]).processed
  end

  def medium_avatar
    model.avatar.variant(resize_to_fill: [300, 300]).processed
  end

  private

  def needs_password_set?
    @needs_password_set.is_a?(TrueClass)
  end
end
