class AddColorToSeatCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :seat_categories, :color, :string, null: false, default: '#000'
  end
end
