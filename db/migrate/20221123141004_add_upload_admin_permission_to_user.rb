class AddUploadAdminPermissionToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :upload_admin_permission, :boolean, default: false, null: false
  end
end
