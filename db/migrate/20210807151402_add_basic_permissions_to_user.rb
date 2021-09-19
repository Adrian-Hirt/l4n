class AddBasicPermissionsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :user_admin_permission, :boolean, default: false, null: false
    add_column :users, :news_admin_permission, :boolean, default: false, null: false
    add_column :users, :event_admin_permission, :boolean, default: false, null: false
  end
end
