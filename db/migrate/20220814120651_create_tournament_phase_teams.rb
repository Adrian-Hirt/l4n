class CreateTournamentPhaseTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_phase_teams do |t|
      t.belongs_to :tournament_phase, null: false, foreign_key: true
      t.belongs_to :tournament_team, null: false, foreign_key: true
      t.integer :seed, null: false

      t.timestamps
    end
  end
end
