class CreateTimetableCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :timetable_categories do |t|
      t.belongs_to :timetable, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :order, null: false, default: '0'

      t.timestamps
    end
  end
end
