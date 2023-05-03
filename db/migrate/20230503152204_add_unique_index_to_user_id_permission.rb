class AddUniqueIndexToUserIdPermission < ActiveRecord::Migration[7.0]
  def change
    add_index :user_permissions, %i[user_id permission], unique: true
  end
end
