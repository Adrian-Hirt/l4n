class AddMoreRobustLinkingToPagesFromMenuItems < ActiveRecord::Migration[7.0]
  def change
    change_column_null :menu_items, :page_name, true
    rename_column :menu_items, :page_name, :static_page_name
    add_column :menu_items, :page_id, :integer, default: nil
  end
end
