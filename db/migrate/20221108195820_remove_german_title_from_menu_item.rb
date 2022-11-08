class RemoveGermanTitleFromMenuItem < ActiveRecord::Migration[7.0]
  def change
    remove_column :menu_items, :title_de, :string, null: false
    rename_column :menu_items, :title_en, :title
  end
end
