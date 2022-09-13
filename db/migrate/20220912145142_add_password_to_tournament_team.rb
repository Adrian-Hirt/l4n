class AddPasswordToTournamentTeam < ActiveRecord::Migration[7.0]
  def change
    add_column :tournament_teams, :password_digest, :string
  end
end
