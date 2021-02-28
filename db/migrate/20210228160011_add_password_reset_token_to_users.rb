class AddPasswordResetTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :password_reset_token_digest, :string
    add_column :users, :password_reset_token_created_at, :datetime
  end
end
