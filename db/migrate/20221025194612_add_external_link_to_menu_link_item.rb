class AddExternalLinkToMenuLinkItem < ActiveRecord::Migration[7.0]
  def change
    add_column :menu_items, :external_link, :string, null: true
  end
end
