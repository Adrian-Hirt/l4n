class CreateTournamentTeamMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_team_members do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :tournament_team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
