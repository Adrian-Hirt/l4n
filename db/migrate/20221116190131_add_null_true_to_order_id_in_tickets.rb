class AddNullTrueToOrderIdInTickets < ActiveRecord::Migration[7.0]
  def change
    change_column_null :tickets, :order_id, true
  end
end
