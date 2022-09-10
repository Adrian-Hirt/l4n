class AddLanPartyAdminPermissionAndTournamentAdminPermissionToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :lan_party_admin_permission, :boolean, null: false, default: false
    add_column :users, :tournament_admin_permission, :boolean, null: false, default: false
  end
end
