class UserPermission < ApplicationRecord
  # == Attributes ==================================================================
  AVAILABLE_PERMISSIONS = {
    'user_admin'        => %w[readonly manage],
    'news_admin'        => %w[manage],
    'event_admin'       => %w[manage],
    'page_admin'        => %w[manage],
    'menu_item_admin'   => %w[manage],
    'shop_admin'        => %w[manage],
    'payment_assist'    => %w[use],
    'lan_party_admin'   => %w[readonly manage],
    'tournament_admin'  => %w[manage],
    'design_admin'      => %w[manage],
    'achievement_admin' => %w[manage],
    'upload_admin'      => %w[readonly manage],
    'developer_admin'   => %w[readonly manage],
    'system_admin'      => %w[manage]
  }.freeze

  SENSITIVE_PERMISSIONS = %w[
    user_admin
    system_admin
  ].freeze

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :user

  # == Validations =================================================================
  validates :permission, presence: true, inclusion: AVAILABLE_PERMISSIONS.keys, uniqueness: { scope: :user_id }
  validates :mode, presence: true
  validates :mode, inclusion: { in: proc { |record| AVAILABLE_PERMISSIONS[record.permission] } }, if: proc { |record| record.permission.present? && record.mode.present? }
  validate :disallow_permission_change_when_persisted
  validate :enforce_2fa_for_sensitive_admin_if_toggled_on

  # == Hooks =======================================================================

  # == Scopes ======================================================================

  # == Class Methods ===============================================================

  # == Instance Methods ============================================================
  def modes_for_permission
    AVAILABLE_PERMISSIONS[permission]
  end

  # == Private Methods =============================================================
  private

  def disallow_permission_change_when_persisted
    return unless persisted?

    errors.add(:permission, _('UserPermission|cannot be changed')) if permission_changed?
  end

  def enforce_2fa_for_sensitive_admin_if_toggled_on
    # If enabled in the settings, an user may only have permission for
    # "sensitive" features if the user has 2FA on their account enabled. This is
    # an additional security feature, which usually should be turned on.

    # If the feature is not enabled, we can just directly return
    return unless AppConfig.enforce_2fa_for_sensitive_admin

    # Otherwise, check wether the requested permission is one of the
    # permissions deemed sensitive
    return unless SENSITIVE_PERMISSIONS.include?(permission.to_s)

    # If the permission is sensitive, the user needs to have 2FA enabled
    # on their account, otherwise we cannot add this.
    return if user.otp_required_for_login?
  end
end
