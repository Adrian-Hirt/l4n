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

  # == Constants ===================================================================

  # == Associations ================================================================
  belongs_to :user

  # == Validations =================================================================
  validates :permission, presence: true, inclusion: AVAILABLE_PERMISSIONS.keys, uniqueness: { scope: :user_id }
  validates :mode, presence: true
  validates :mode, inclusion: { in: proc { |record| AVAILABLE_PERMISSIONS[record.permission] } }, if: proc { |record| record.permission.present? && record.mode.present? }
  validate :disallow_permission_change_when_persisted

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
end
