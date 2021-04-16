class CreateEventDates < ActiveRecord::Migration[6.1]
  def change
    create_table :event_dates do |t|
      t.date :start_date, null: false
      t.time :start_time
      t.date :end_date
      t.time :end_time
      t.belongs_to :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
