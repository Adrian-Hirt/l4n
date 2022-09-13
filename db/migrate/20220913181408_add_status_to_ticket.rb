class AddStatusToTicket < ActiveRecord::Migration[7.0]
  def change
    add_column :tickets, :status, :string, null: false, default: 'created'
  end
end
