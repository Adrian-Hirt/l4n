class AddNameToSeats < ActiveRecord::Migration[7.0]
  def change
    add_column :seats, :name, :string, null: true
  end
end
