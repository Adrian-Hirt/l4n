class CreateTimetableEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :timetable_entries do |t|
      t.belongs_to :timetable_category, null: false, foreign_key: true
      t.string :title, null: false
      t.datetime :entry_start, null: false
      t.datetime :entry_end, null: false
      t.string :link

      t.timestamps
    end
  end
end
