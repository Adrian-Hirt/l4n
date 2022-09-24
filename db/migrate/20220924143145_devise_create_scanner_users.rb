# frozen_string_literal: true

class DeviseCreateScannerUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :scanner_users do |t|
      ## Database authenticatable
      t.string :name, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.timestamps null: false
    end

    add_index :scanner_users, :name, unique: true
  end
end
