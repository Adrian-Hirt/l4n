class AddStatusAndNameToTournamentTeam < ActiveRecord::Migration[7.0]
  def change
    add_column :tournament_teams, :status, :string, null: false
    add_column :tournament_teams, :name, :string, null: false
  end
end
