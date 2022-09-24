class AddDeviseTwoFactorToUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :otp_secret_key, :string
    remove_column :users, :two_factor_enabled, :boolean, default: false
    remove_column :users, :otp_backup_codes, :text

    add_column :users, :otp_secret, :string
    add_column :users, :consumed_timestep, :integer
    add_column :users, :otp_required_for_login, :boolean
    add_column :users, :otp_backup_codes, :string, array: true
  end
end
