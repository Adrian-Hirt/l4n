class CreatePromotions < ActiveRecord::Migration[7.0]
  def change
    create_table :promotions do |t|
      t.string :name, null: false
      t.boolean :active, null: false, default: false
      t.string :code_type, null: false
      t.monetize :reduction, currency: { present: false }, amount: { null: true, default: nil }
      t.string :code_prefix

      t.index :name, unique: true

      t.timestamps
    end
  end
end
