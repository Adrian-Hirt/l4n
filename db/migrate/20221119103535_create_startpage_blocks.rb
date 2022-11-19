class CreateStartpageBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :startpage_blocks do |t|
      t.boolean :visible, null: false, default: true
      t.string :title
      t.text :content
      t.integer :sort, null: false, default: 0

      t.timestamps
    end
  end
end
