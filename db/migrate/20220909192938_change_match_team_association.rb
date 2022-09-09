class ChangeMatchTeamAssociation < ActiveRecord::Migration[7.0]
  def change
    change_table :tournament_matches do |t|
      t.remove_belongs_to :home_team, null: true, foreign_key: { to_table: :tournament_teams }
      t.remove_belongs_to :away_team, null: true, foreign_key: { to_table: :tournament_teams }
      t.remove_belongs_to :winner, null: true, foreign_key: { to_table: :tournament_teams }

      t.belongs_to :home, null: true, foreign_key: { to_table: :tournament_phase_teams }
      t.belongs_to :away, null: true, foreign_key: { to_table: :tournament_phase_teams }
      t.belongs_to :winner, null: true, foreign_key: { to_table: :tournament_phase_teams }
    end
  end
end
