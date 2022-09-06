class MoveScoreFromTeamToPhaseTeam < ActiveRecord::Migration[7.0]
  def change
    add_column :tournament_phase_teams, :score, :integer, null: false, default: 0
    remove_column :tournament_teams, :score, :integer, null: false, default: 0
  end
end
