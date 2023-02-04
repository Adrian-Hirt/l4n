class AddColumnsForMultipleActiveLanParties < ActiveRecord::Migration[7.0]
  def change
    add_column :lan_parties, :sidebar_active, :boolean, null: false, default: true
    add_column :lan_parties, :sort, :integer, null: false, default: 0
    add_column :lan_parties, :timetable_enabled, :boolean, null: false, default: true
    add_column :lan_parties, :seatmap_enabled, :boolean, null: false, default: true
  end
end
