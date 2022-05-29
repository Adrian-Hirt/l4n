class AddSizingFieldsToSeatMap < ActiveRecord::Migration[7.0]
  def change
    add_column :seat_maps, :background_height, :integer, default: 0, null: false
    add_column :seat_maps, :background_width, :integer, default: 0, null: false
    add_column :seat_maps, :canvas_height, :integer, default: 500, null: false
    add_column :seat_maps, :canvas_width, :integer, default: 800, null: false
  end
end
