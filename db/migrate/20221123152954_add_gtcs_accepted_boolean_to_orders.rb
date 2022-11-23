class AddGtcsAcceptedBooleanToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :gtcs_accepted, :boolean, default: false, null: false
  end
end
