class User < ApplicationRecord
  # == Attributes ==================================================================
  attr_writer :needs_password_set

  has_secure_password
  has_secure_password :remember_me_token, validations: false
  has_secure_password :password_reset_token, validations: false

  has_one_time_password one_time_backup_codes: true
  serialize :otp_backup_codes, JSON

  # == Constants ===================================================================
  RESET_TOKEN_EXPIRES_AFTER = 6.hours

  PERMISSION_FIELDS = %i[
    user_admin_permission
    news_admin_permission
    event_admin_permission
    page_admin_permission
    menu_items_admin_permission
    shop_admin_permission
    system_admin_permission
  ].freeze

  # == Associations ================================================================
  # Avatar image
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
    attachable.variant :medium, resize_to_fill: [300, 300]
  end

  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :user_addresses, dependent: :destroy

  # == Validations =================================================================
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }, length: { maximum: 255 }
  validates :password, presence: true, length: { minimum: 10, maximum: 72 }, confirmation: true, if: -> { password.present? || new_record? || needs_password_set? }
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates :use_dark_mode, inclusion: [true, false]
  validates :website, length: { maximum: 255 }
  validates :avatar, size: { less_than: 5.megabytes, message: format(_('File is too large, max. allowed %{size}'), size: '5MB') }, content_type: %r{\Aimage/.*\z}

  # Permission booleans
  PERMISSION_FIELDS.each do |field|
    validates field, inclusion: [true, false]
  end

  # == Hooks =======================================================================
  before_save { self.email = email.downcase } # turns email to downcase for uniqueness

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def destroyable?
    true
  end

  def any_admin_permission?
    User::PERMISSION_FIELDS.any? { |permission| send(permission) }
  end

  # == Private Methods =============================================================
  private

  def needs_password_set?
    @needs_password_set.is_a?(TrueClass)
  end
end
