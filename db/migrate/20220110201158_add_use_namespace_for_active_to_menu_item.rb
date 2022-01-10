class AddUseNamespaceForActiveToMenuItem < ActiveRecord::Migration[7.0]
  def change
    add_column :menu_items, :use_namespace_for_active_detection, :boolean, null: false, default: false
  end
end
