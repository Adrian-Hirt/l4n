class CreateTournamentMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_matches do |t|
      t.belongs_to :tournament_round, null: false, foreign_key: true
      t.belongs_to :home_team, null: true, foreign_key: { to_table: :tournament_teams }
      t.belongs_to :away_team, null: true, foreign_key: { to_table: :tournament_teams }
      t.belongs_to :winner, null: true, foreign_key: { to_table: :tournament_teams }

      t.timestamps
    end
  end
end
