class CreatePromotionProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :promotion_products do |t|
      t.references :product, null: false, foreign_key: true
      t.references :promotion, null: false, foreign_key: true

      t.timestamps
    end
  end
end
