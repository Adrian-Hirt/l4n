class CreateTournaments < ActiveRecord::Migration[7.0]
  def change
    create_table :tournaments do |t|
      t.string :name, null: false
      t.integer :team_size, null: false

      t.timestamps
    end
  end
end
