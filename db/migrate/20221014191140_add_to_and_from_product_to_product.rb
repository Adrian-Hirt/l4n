class AddToAndFromProductToProduct < ActiveRecord::Migration[7.0]
  def change
    add_belongs_to :products, :from_product, null: true, foreign_key: { to_table: :products }
    add_belongs_to :products, :to_product, null: true, foreign_key: { to_table: :products }
  end
end
