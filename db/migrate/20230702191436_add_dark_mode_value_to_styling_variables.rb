class AddDarkModeValueToStylingVariables < ActiveRecord::Migration[7.0]
  def change
    rename_column :styling_variables, :value, :light_mode_value
    change_column_null :styling_variables, :light_mode_value, true
    add_column :styling_variables, :dark_mode_value, :string, null: true
  end
end
