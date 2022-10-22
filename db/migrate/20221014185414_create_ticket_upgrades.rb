class CreateTicketUpgrades < ActiveRecord::Migration[7.0]
  def change
    create_table :ticket_upgrades do |t|
      t.belongs_to :lan_party, null: false, foreign_key: true
      t.belongs_to :from_product, null: false, foreign_key: { to_table: :products }
      t.belongs_to :to_product, null: false, foreign_key: { to_table: :products }
      t.belongs_to :order, null: false, foreign_key: true
      t.boolean :used, null: false, default: false

      t.timestamps
    end
  end
end
