class CreateSeatMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :seat_maps do |t|
      t.belongs_to :lan_party, null: false, foreign_key: true

      t.timestamps
    end
  end
end
