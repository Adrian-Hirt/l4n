class AddResultStatusToTournamentMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :tournament_matches, :result_status, :string, null: false, default: 'missing'
    add_belongs_to :tournament_matches, :reporter, null: true, foreign_key: { to_table: :tournament_phase_teams }
  end
end
