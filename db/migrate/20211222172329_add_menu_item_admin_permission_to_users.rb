class AddMenuItemAdminPermissionToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :menu_items_admin_permission, :boolean, null: false, default: false
  end
end
