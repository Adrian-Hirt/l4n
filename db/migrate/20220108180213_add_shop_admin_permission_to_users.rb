class AddShopAdminPermissionToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :shop_admin_permission, :boolean, null: false, default: false
  end
end
