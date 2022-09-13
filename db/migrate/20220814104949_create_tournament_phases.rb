class CreateTournamentPhases < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_phases do |t|
      t.belongs_to :tournament, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :phase_number, null: false
      t.string :tournament_mode, null: false

      t.timestamps
    end
  end
end
