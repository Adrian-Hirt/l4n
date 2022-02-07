class AddProductNameToOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :product_name, :string, null: true
  end
end
