class AddSeatCategoryToProduct < ActiveRecord::Migration[7.0]
  def change
    add_belongs_to :products, :seat_category, null: true
  end
end
