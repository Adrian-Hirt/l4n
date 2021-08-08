class AddSystemAdminPermissionToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :system_admin_permission, :boolean, default: false, null: false
  end
end
