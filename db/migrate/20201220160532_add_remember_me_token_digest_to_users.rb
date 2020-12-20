class AddRememberMeTokenDigestToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :remember_me_token_digest, :string, null: true
  end
end
