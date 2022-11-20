class SwitchConfirmationToDeviseConfirmable < ActiveRecord::Migration[7.0]
  def change
    # Add new columns
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime

    # Add new index
    add_index :users, :confirmation_token, unique: true

    # Drop old columns
    remove_column :users, :activation_token, :string
    remove_column :users, :activated, :boolean, default: false, null: false
  end
end
