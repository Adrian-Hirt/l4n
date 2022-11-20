class AddAchievementPermissionToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :achievement_admin_permission, :boolean, default: false, null: false
  end
end
