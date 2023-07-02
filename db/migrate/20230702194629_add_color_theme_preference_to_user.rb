class AddColorThemePreferenceToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :color_theme_preference, :string, null: false, default: 'auto'
    remove_column :users, :use_dark_mode, :boolean, null: false
  end
end
