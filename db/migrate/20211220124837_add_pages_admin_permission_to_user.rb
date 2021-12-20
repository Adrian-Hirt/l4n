class AddPagesAdminPermissionToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :page_admin_permission, :boolean, default: false, null: false
  end
end
