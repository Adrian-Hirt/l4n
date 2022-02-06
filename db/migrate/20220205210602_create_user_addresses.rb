class CreateUserAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :user_addresses do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :street, null: false
      t.string :zip_code, null: false
      t.string :city, null: false

      t.timestamps
    end
  end
end
