class AddAutoProgressToTournamentPhase < ActiveRecord::Migration[7.0]
  def change
    add_column :tournament_phases, :auto_progress, :boolean, null: false, default: false
  end
end
