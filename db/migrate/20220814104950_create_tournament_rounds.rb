class CreateTournamentRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_rounds do |t|
      t.belongs_to :tournament_phase, null: false, foreign_key: true
      t.integer :round_number, null: false

      t.timestamps
    end
  end
end
