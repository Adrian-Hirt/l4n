class User < ApplicationRecord
  ################################### Attributes ###################################
  attr_writer :needs_password_set

  has_secure_password validations: false
  has_secure_password :remember_me_token, validations: false
  has_secure_password :password_reset_token, validations: false

  has_one_time_password one_time_backup_codes: true
  serialize :otp_backup_codes, JSON

  ################################### Constants ####################################
  RESET_TOKEN_EXPIRES_AFTER = 6.hours
  REMEMBER_ME_TOKEN_EXPIRES_AFTER = 2.weeks

  ADMIN_SIDEBAR_HIGHLIGHT_COLORS = [
    ['primary', _('Highlightcolors|Blue')],
    ['secondary', _('Highlightcolors|Grey')],
    ['warning', _('Highlightcolors|Yellow')],
    ['danger', _('Highlightcolors|Red')],
    ['success', _('Highlightcolors|Green')],
    ['lime', _('Highlightcolors|Lime')],
    ['purple', _('Highlightcolors|Purple')],
    ['orange', _('Highlightcolors|Orange')],
    ['fuchsia', _('Highlightcolors|Fuchsia')]
  ].freeze

  ################################### Associations #################################
  # Avatar image
  has_one_attached :avatar

  ################################### Validations ##################################
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 10, maximum: 72 }, confirmation: true, if: -> { password.present? || new_record? || needs_password_set? }
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :admin_panel_dark_mode, inclusion: [true, false]
  validates :frontend_dark_mode, inclusion: [true, false]

  ################################### Scopes #######################################

  ################################### Class Methods ################################

  ################################### Instance Methods #############################
  def thumb_avatar
    avatar.variant(resize_to_fill: [100, 100])&.processed
  end

  def medium_avatar
    avatar.variant(resize_to_fill: [300, 300])&.processed
  end

  ################################### Private Methods ##############################
  private

  def needs_password_set?
    @needs_password_set.is_a?(TrueClass)
  end
end
