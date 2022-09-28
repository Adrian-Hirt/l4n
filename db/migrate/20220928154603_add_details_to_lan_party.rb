class AddDetailsToLanParty < ActiveRecord::Migration[7.0]
  def change
    add_column :lan_parties, :event_start, :datetime, null: true
    add_column :lan_parties, :event_end, :datetime, null: true
    add_column :lan_parties, :location, :string, null: true
  end
end
