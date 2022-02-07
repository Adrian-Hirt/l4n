class AddEnabledProductBehavioursToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :enabled_product_behaviours, :string, null: true, default: nil
  end
end
