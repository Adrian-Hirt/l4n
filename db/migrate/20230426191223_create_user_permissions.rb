class CreateUserPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_permissions do |t|
      t.string :permission, null: false
      t.string :mode, null: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
