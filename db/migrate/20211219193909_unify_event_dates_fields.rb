class UnifyEventDatesFields < ActiveRecord::Migration[7.0]
  def up
    change_column :event_dates, :start_date, :datetime
    change_column :event_dates, :end_date, :datetime, null: false
    remove_column :event_dates, :start_time
    remove_column :event_dates, :end_time
  end

  def down
    change_column :event_dates, :start_date, :date
    change_column :event_dates, :end_date, :date, null: true
    add_column :event_dates, :start_time, :time
    add_column :event_dates, :end_time, :time
  end
end
