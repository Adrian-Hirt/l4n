class CreateNewsPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :news_posts do |t|
      t.string :title, null: false
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.boolean :published, default: false, null: false
      t.timestamp :published_at

      t.timestamps
    end
  end
end
