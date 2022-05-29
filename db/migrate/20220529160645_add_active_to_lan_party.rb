class AddActiveToLanParty < ActiveRecord::Migration[7.0]
  def change
    add_column :lan_parties, :active, :boolean, default: false, null: false
  end
end
