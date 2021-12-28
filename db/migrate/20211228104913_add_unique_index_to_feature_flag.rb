class AddUniqueIndexToFeatureFlag < ActiveRecord::Migration[7.0]
  def change
    remove_index :feature_flags, :key
    add_index :feature_flags, :key, unique: true
  end
end
