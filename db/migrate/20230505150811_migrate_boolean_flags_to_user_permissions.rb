class MigrateBooleanFlagsToUserPermissions < ActiveRecord::Migration[7.0]
  USER_FIELDS_TO_USER_PERMISSIONS = {
    'user_admin_permission'        => 'user_admin',
    'news_admin_permission'        => 'news_admin',
    'event_admin_permission'       => 'event_admin',
    'page_admin_permission'        => 'page_admin',
    'menu_items_admin_permission'  => 'menu_item_admin',
    'shop_admin_permission'        => 'shop_admin',
    'lan_party_admin_permission'   => 'lan_party_admin',
    'tournament_admin_permission'  => 'tournament_admin',
    'design_admin_permission'      => 'design_admin',
    'achievement_admin_permission' => 'achievement_admin',
    'upload_admin_permission'      => 'upload_admin',
    'developer_admin_permission'   => 'developer_admin',
    'system_admin_permission'      => 'system_admin'
  }.freeze

  def up
    # For each flag we have on the user, we create a `manage`
    # UserPermission for the respective user / permission combo.
    # As we previously did not have readonly admin access, this can
    # be easily done without losing any permissions. The only exception
    # is `payment_assist`, where the mode is `use`.
    USER_FIELDS_TO_USER_PERMISSIONS.each do |boolean_field, permission|
      execute <<~SQL.squish
        INSERT INTO user_permissions(permission, mode, user_id, created_at, updated_at) (
          SELECT '#{permission}', 'manage', id, NOW(), NOW() FROM users WHERE #{boolean_field} =TRUE
        )
      SQL
    end

    execute <<~SQL.squish
      INSERT INTO user_permissions(permission, mode, user_id, created_at, updated_at) (
        SELECT 'payment_assist', 'use', id, NOW(), NOW() FROM users WHERE payment_assist_admin_permission = TRUE
      )
    SQL

    # Remove all boolean columns on the user model, as we're not using these anymore.
    USER_FIELDS_TO_USER_PERMISSIONS.each_key do |field|
      remove_column :users, field
    end

    remove_column :users, :payment_assist_admin_permission
  end

  def down
    # For each UserPermission on an user, we create an entry in
    # the boolean column, if that permission has mode `manage`.
    # Please not that we did not have any other modes than `manage`
    # before, and to avoid granting someone too much access, we lose
    # just remove the permissions which were not `manage`, the only
    # exception is the `payment_assist` permissions, where the only
    # mode is `use`.

    # Add boolean columns with defaults
    USER_FIELDS_TO_USER_PERMISSIONS.each_key do |field|
      add_column :users, field, :boolean, default: false, null: false
    end

    # Migrate user_permissions to boolean columns
    USER_FIELDS_TO_USER_PERMISSIONS.each do |boolean_field, permission|
      execute <<~SQL.squish
        UPDATE users
        SET #{boolean_field} = TRUE
        WHERE id IN (
          SELECT user_id
          FROM user_permissions
          WHERE permission = '#{permission}'
          AND mode = 'manage'
        )
      SQL
    end

    execute <<~SQL.squish
      UPDATE users
      SET payment_assist_admin_permission = TRUE
      WHERE id IN (
        SELECT user_id
        FROM user_permissions
        WHERE permission = 'payment_assist'
        AND mode = 'use'
      )
    SQL

    # Remove all data from user permissions table
    execute <<~SQL.squish
      DELETE FROM user_permissions
    SQL
  end
end
