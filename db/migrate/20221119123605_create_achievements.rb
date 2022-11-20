class CreateAchievements < ActiveRecord::Migration[7.0]
  def change
    create_table :achievements do |t|
      t.string :title, null: false
      t.string :description
      t.belongs_to :lan_party, null: true

      t.timestamps
    end
  end
end
