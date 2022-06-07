class CreateProductCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :product_categories do |t|
      t.string :name, null: false
      t.integer :sort, default: 0, null: false
      t.index :name, unique: true

      t.timestamps
    end
  end
end
