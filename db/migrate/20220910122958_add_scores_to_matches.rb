class AddScoresToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :tournament_matches, :home_score, :integer, null: false, default: 0
    add_column :tournament_matches, :away_score, :integer, null: false, default: 0
  end
end
