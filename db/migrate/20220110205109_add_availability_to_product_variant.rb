class AddAvailabilityToProductVariant < ActiveRecord::Migration[7.0]
  def change
    add_column :product_variants, :availability, :integer, null: false, default: 0
  end
end
