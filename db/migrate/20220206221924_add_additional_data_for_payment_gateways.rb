class AddAdditionalDataForPaymentGateways < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :payment_gateway_name, :string
    add_column :orders, :payment_gateway_payment_id, :string
  end
end
