class AddUseSidebarToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :use_sidebar, :boolean, null: false, default: true
  end
end
