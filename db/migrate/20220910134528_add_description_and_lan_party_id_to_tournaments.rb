class AddDescriptionAndLanPartyIdToTournaments < ActiveRecord::Migration[7.0]
  def change
    change_table :tournaments do |t|
      t.belongs_to :lan_party, null: true
      t.text :description
    end
  end
end
