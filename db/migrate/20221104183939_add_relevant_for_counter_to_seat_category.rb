class AddRelevantForCounterToSeatCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :seat_categories, :relevant_for_counter, :boolean, default: true, null: false
  end
end
