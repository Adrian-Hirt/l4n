class CreateTournamentTeamRanks < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_team_ranks do |t|
      t.belongs_to :tournament, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :sort, null: false, default: 0

      t.timestamps

      t.index %i[name tournament_id], unique: true
    end

    add_column :tournaments, :teams_need_rank, :boolean, null: false, default: false
    add_belongs_to :tournament_teams, :tournament_team_rank, foreign_key: true, null: true
  end
end
