class User < ApplicationRecord
  ################################### Attributes ###################################
  attr_writer :needs_password_set

  has_secure_password
  has_secure_password :remember_me_token, validations: false
  has_secure_password :password_reset_token, validations: false

  has_one_time_password one_time_backup_codes: true
  serialize :otp_backup_codes, JSON

  ################################### Constants ####################################
  RESET_TOKEN_EXPIRES_AFTER = 6.hours

  PERMISSION_FIELDS = %i[
    user_admin_permission
    news_admin_permission
    event_admin_permission
    system_admin_permission
  ].freeze

  ################################### Associations #################################
  # Avatar image
  has_one_attached :avatar

  ################################### Validations ##################################
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 10, maximum: 72 }, confirmation: true, if: -> { password.present? || new_record? || needs_password_set? }
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :use_dark_mode, inclusion: [true, false]

  # Permission booleans
  PERMISSION_FIELDS.each do |field|
    validates field, inclusion: [true, false]
  end

  ################################### Hooks #######################################
  before_save { self.email = email.downcase } # turns email to downcase for uniqueness

  ################################### Scopes #######################################

  ################################### Class Methods ################################

  ################################### Instance Methods #############################
  def thumb_avatar
    avatar.variant(resize_to_fill: [100, 100])&.processed
  end

  def medium_avatar
    avatar.variant(resize_to_fill: [300, 300])&.processed
  end

  def destroyable?
    true
  end

  def any_admin_permission?
    User::PERMISSION_FIELDS.any? { |permission| send(permission) }
  end

  ################################### Private Methods ##############################
  private

  def needs_password_set?
    @needs_password_set.is_a?(TrueClass)
  end
end
