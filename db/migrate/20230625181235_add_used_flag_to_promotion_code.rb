class AddUsedFlagToPromotionCode < ActiveRecord::Migration[7.0]
  def up
    add_column :promotion_codes, :used, :boolean, null: false, default: false

    execute <<~SQL.squish
      UPDATE promotion_codes
      SET used = true
      WHERE id IN (
        SELECT promotion_code_id
        FROM promotion_code_mappings
      )
    SQL
  end

  def down
    remove_column :promotion_codes, :used
  end
end
