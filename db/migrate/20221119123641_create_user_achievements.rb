class CreateUserAchievements < ActiveRecord::Migration[7.0]
  def change
    create_table :user_achievements do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :achievement, null: false, foreign_key: true
      t.datetime :awarded_at, null: false

      t.timestamps

      t.index %i[user_id achievement_id], unique: true
    end
  end
end
