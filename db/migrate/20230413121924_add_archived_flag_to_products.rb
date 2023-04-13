class AddArchivedFlagToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :archived, :boolean, null: false, default: false
  end
end
