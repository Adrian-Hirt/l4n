class AddProfileFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :bio, :text
    add_column :users, :steam_id, :string
    add_column :users, :discord_id, :string
  end
end
