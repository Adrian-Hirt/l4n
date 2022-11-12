class CreateStylingVariables < ActiveRecord::Migration[7.0]
  def change
    create_table :styling_variables do |t|
      t.string :key, null: false
      t.string :value, null: false

      t.timestamps

      t.index :key, unique: true
    end
  end
end
