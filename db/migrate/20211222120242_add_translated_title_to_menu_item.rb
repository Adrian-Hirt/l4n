class AddTranslatedTitleToMenuItem < ActiveRecord::Migration[7.0]
  def change
    remove_column :menu_items, :title, :string
    add_column :menu_items, :title_en, :string, null: false
    add_column :menu_items, :title_de, :string, null: false
    change_column_null :menu_items, :page_name, true
  end
end
