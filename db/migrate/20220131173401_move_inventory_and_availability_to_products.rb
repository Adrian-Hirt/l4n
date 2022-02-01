class MoveInventoryAndAvailabilityToProducts < ActiveRecord::Migration[7.0]
  def change
    remove_column :product_variants, :availability, :integer, null: false, default: 0
    remove_column :product_variants, :inventory, :integer, null: false, default: 0

    add_column :products, :availability, :integer, null: false, default: 0
    add_column :products, :inventory, :integer, null: false, default: 0
  end
end
