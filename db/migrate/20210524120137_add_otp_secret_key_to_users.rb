class AddOtpSecretKeyToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :otp_secret_key, :string
    add_column :users, :two_factor_enabled, :boolean, default: false
  end
end
