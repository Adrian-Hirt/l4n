class AddDrawToMatch < ActiveRecord::Migration[7.0]
  def change
    add_column :tournament_matches, :draw, :boolean, null: false, default: false
  end
end
