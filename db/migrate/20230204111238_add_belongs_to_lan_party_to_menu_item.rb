class AddBelongsToLanPartyToMenuItem < ActiveRecord::Migration[7.0]
  def change
    add_belongs_to :menu_items, :lan_party, null: true
  end
end
