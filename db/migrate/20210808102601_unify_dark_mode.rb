class UnifyDarkMode < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :frontend_dark_mode, :use_dark_mode
    remove_column :users, :admin_panel_dark_mode, :boolean, null: false, default: false
  end
end
