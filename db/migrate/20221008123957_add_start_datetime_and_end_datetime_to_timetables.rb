class AddStartDatetimeAndEndDatetimeToTimetables < ActiveRecord::Migration[7.0]
  def change
    add_column :timetables, :start_datetime, :datetime, null: true
    add_column :timetables, :end_datetime, :datetime, null: true
  end
end
