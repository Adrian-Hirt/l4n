class AddStiTypeToMenuItem < ActiveRecord::Migration[7.0]
  def change
    add_column :menu_items, :type, :string, null: false, default: 'MenuLinkItem'
    remove_column :menu_items, :item_type, :string, null: false, default: 'link_type'
  end
end
