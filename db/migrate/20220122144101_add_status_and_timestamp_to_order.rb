class AddStatusAndTimestampToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :cleanup_timestamp, :datetime, null: true
    add_column :orders, :status, :string, null: false, default: 'created'
  end
end
