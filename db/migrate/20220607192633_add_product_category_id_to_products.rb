class AddProductCategoryIdToProducts < ActiveRecord::Migration[7.0]
  def change
    add_reference :products, :product_category, index: true, foreign_key: true
  end
end
