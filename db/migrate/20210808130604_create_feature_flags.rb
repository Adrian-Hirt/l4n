class CreateFeatureFlags < ActiveRecord::Migration[6.1]
  def change
    create_table :feature_flags do |t|
      t.string :key, index: true, unique: true
      t.boolean :enabled, default: false, null: false

      t.timestamps
    end
  end
end
