class AddUserMayHaveMultipleTicketsAssignedToLanParty < ActiveRecord::Migration[7.0]
  def change
    add_column :lan_parties, :users_may_have_multiple_tickets_assigned, :boolean, default: false, null: false
  end
end
