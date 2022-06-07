class AddSortToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :sort, :integer, null: false, default: 0
  end
end
