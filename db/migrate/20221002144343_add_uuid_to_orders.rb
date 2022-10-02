class AddUuidToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :uuid, :uuid, default: 'gen_random_uuid()'

    add_index :orders, :uuid, unique: true
  end
end
