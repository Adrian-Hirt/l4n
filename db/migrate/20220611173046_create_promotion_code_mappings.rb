class CreatePromotionCodeMappings < ActiveRecord::Migration[7.0]
  def up
    create_table :promotion_code_mappings do |t|
      t.references :order, null: false, foreign_key: true
      t.references :promotion_code, null: false, foreign_key: true
      t.references :order_item, null: true
      t.monetize :applied_reduction, currency: { present: false }, amount: { null: true, default: nil }

      t.timestamps
    end

    execute <<~SQL.squish
      INSERT INTO promotion_code_mappings (order_id, promotion_code_id, created_at, updated_at)
      (
        SELECT order_id, id, created_at, updated_at
        FROM promotion_codes
        WHERE order_id IS NOT NULL
      )
    SQL

    remove_column :promotion_codes, :order_id
  end

  def down
    add_reference :promotion_codes, :order, null: true, foreign_key: true

    execute <<~SQL.squish
      UPDATE promotion_codes
      SET order_id = promotion_code_mappings.order_id
      FROM promotion_code_mappings
      WHERE promotion_codes.id = promotion_code_mappings.promotion_code_id
    SQL

    drop_table :promotion_code_mappings
  end
end
