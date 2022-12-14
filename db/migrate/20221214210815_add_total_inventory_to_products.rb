class AddTotalInventoryToProducts < ActiveRecord::Migration[7.0]
  def up
    add_column :products, :total_inventory, :integer, null: false, default: 0

    # Copy from existing, might need to manually adjust!
    execute <<~SQL.squish
      UPDATE products
      SET total_inventory = inventory
    SQL
  end

  def down
    remove_column :products, :inventory, :integer, null: false, default: 0
  end
end
