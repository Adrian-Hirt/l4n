class AddUniqueIndexForTeamName < ActiveRecord::Migration[7.0]
  def change
    add_index :tournament_teams, %i[name tournament_id], unique: true
  end
end
