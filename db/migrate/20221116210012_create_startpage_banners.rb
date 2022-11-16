class CreateStartpageBanners < ActiveRecord::Migration[7.0]
  def change
    create_table :startpage_banners do |t|
      t.string :name, null: false
      t.boolean :visible, null: false, default: false
      t.integer :height, null: false

      t.timestamps
    end
  end
end
