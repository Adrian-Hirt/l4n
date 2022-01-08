class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false, index: { unique: true }
      t.text :description
      t.boolean :on_sale, null: false, default: false
      t.string :type

      t.timestamps
    end
  end
end
