class CreateTimetables < ActiveRecord::Migration[7.0]
  def change
    create_table :timetables do |t|
      t.belongs_to :lan_party, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
