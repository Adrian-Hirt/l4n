class AddLocationToEventDate < ActiveRecord::Migration[7.0]
  def up
    add_column :event_dates, :location, :string

    # Copy from existing
    execute <<~SQL.squish
      UPDATE event_dates
      SET location = events.location
      FROM events
      WHERE events.id = event_dates.event_id
    SQL

    remove_column :events, :location
  end

  def down
    add_column :events, :location, :string
    remove_column :event_dates, :location
  end
end
