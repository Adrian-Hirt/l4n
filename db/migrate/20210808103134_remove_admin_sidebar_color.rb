class RemoveAdminSidebarColor < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :admin_sidebar_highlight_color, :string
  end
end
