# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[7.0]
  def self.up
    change_table :users do |t|
      # Database authenticatable
      t.string :encrypted_password, null: false, default: ''

      # Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      # Rememberable
      t.datetime :remember_created_at
    end

    remove_column :users, :password_digest, :string, null: false
    remove_column :users, :remember_me_token_digest, :string
    remove_column :users, :remember_me_token_created_at, :datetime
    remove_column :users, :password_reset_token_digest, :string
    remove_column :users, :password_reset_token_created_at, :datetime

    add_index :users, :reset_password_token, unique: true
  end
end
