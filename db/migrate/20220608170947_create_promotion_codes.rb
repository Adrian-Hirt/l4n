class CreatePromotionCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :promotion_codes do |t|
      t.references :promotion, null: false, foreign_key: true
      t.string :code, null: false
      t.boolean :used, null: false, default: false
      t.references :order, null: true, foreign_key: true

      t.index :code, unique: true

      t.timestamps
    end
  end
end
