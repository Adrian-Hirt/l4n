class CreateSeats < ActiveRecord::Migration[7.0]
  def change
    create_table :seats do |t|
      t.belongs_to :seat_map, null: false, foreign_key: true
      t.belongs_to :seat_category, null: false, foreign_key: true
      t.json :data

      t.timestamps
    end
  end
end
