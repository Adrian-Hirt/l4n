class CreateProductVariants < ActiveRecord::Migration[7.0]
  def change
    create_table :product_variants do |t|
      t.string :name
      t.belongs_to :product, null: false, foreign_key: true
      t.monetize :price, currency: { present: false }
      t.integer :inventory, null: false, default: 0

      t.timestamps
    end
  end
end
