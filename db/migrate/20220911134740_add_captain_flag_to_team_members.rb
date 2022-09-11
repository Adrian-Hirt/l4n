class AddCaptainFlagToTeamMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :tournament_team_members, :captain, :boolean, null: false, default: false
  end
end
