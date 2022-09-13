class AddFrontendOrderToTournaments < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :frontend_order, :integer, null: false, default: 0
  end
end
