class CreateApiApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :api_applications do |t|
      t.string :name, null: false
      t.string :api_key, null: false

      t.timestamps
    end

    add_index :api_applications, :name, unique: true
  end
end
