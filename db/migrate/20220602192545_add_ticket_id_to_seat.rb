class AddTicketIdToSeat < ActiveRecord::Migration[7.0]
  def change
    add_reference :seats, :ticket, null: true, foreign_key: true
  end
end
