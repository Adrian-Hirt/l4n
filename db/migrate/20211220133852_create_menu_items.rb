class CreateMenuItems < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_items do |t|
      t.string :title
      t.integer :sort, null: false, default: 0
      t.references :parent, null: true
      t.string :page_name, null: false
      t.boolean :visible, null: false, default: false

      t.timestamps
    end
  end
end
