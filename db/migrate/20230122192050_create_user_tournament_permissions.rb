class CreateUserTournamentPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_tournament_permissions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :tournament, null: false, foreign_key: true

      t.timestamps

      t.index %i[user_id tournament_id], unique: true
    end
  end
end
