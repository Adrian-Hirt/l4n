class CreateSeatCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :seat_categories do |t|
      t.belongs_to :lan_party, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
