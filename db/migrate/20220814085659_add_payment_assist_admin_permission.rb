class AddPaymentAssistAdminPermission < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :payment_assist_admin_permission, :boolean, null: false, default: false
  end
end
