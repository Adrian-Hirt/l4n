class CreateTournamentTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_teams do |t|
      t.belongs_to :tournament, null: false, foreign_key: true

      t.timestamps
    end
  end
end
