class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.text :content
      t.boolean :published, null: false
      t.string :url, null: false

      t.index :title, unique: true
      t.index :url, unique: true
      t.timestamps
    end
  end
end
