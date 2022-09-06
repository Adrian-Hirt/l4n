class AddSizeToTournamentPhase < ActiveRecord::Migration[7.0]
  def change
    add_column :tournament_phases, :size, :integer, null: true, default: nil
  end
end
