class AddFrontendDarkModeToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :frontend_dark_mode, :boolean, null: false, default: false
    remove_column :users, :admin_panel_sidebar_dark_mode, :boolean, null: false, default: true
  end
end
