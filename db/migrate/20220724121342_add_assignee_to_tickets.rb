class AddAssigneeToTickets < ActiveRecord::Migration[7.0]
  def change
    add_belongs_to :tickets, :assignee, null: true
  end
end
