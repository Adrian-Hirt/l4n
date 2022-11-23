class AddVariantnameToTicket < ActiveRecord::Migration[7.0]
  def change
    add_column :tickets, :product_variant_name, :string, null: true
  end
end
