class AddBelongsToLanPartyToScannerUser < ActiveRecord::Migration[7.0]
  def change
    add_belongs_to :scanner_users, :lan_party, null: true
  end
end
