class AddAdminDarkModeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin_panel_dark_mode, :boolean, null: false, default: false
    add_column :users, :admin_panel_sidebar_dark_mode, :boolean, null: false, default: true
    add_column :users, :admin_sidebar_highlight_color, :string
  end
end
