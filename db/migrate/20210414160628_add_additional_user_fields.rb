class AddAdditionalUserFields < ActiveRecord::Migration[6.1]
  def change
    # Username, must be unique
    add_column :users, :username, :string, null: false
    add_index :users, :username, unique: true

    # Bio, users can write something about themselfes
    add_column :users, :website, :string
  end
end
