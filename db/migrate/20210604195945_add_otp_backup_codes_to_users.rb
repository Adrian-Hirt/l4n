class AddOtpBackupCodesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :otp_backup_codes, :text
  end
end
