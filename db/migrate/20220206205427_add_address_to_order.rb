class AddAddressToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :billing_address_first_name, :string
    add_column :orders, :billing_address_last_name, :string
    add_column :orders, :billing_address_street, :string
    add_column :orders, :billing_address_zip_code, :string
    add_column :orders, :billing_address_city, :string
  end
end
