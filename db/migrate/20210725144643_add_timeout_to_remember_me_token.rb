class AddTimeoutToRememberMeToken < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :remember_me_token_created_at, :datetime, after: :remember_me_token_digest
  end
end
