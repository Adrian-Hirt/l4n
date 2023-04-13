class AddDefaultsAndNotNullToBooleanColumns < ActiveRecord::Migration[7.0]
  def up
    # Update all columns where they might have a value of NULL
    execute <<~SQL.squish
      UPDATE pages SET published = FALSE
      WHERE published IS NULL
    SQL

    execute <<~SQL.squish
      UPDATE users SET otp_required_for_login = FALSE
      WHERE otp_required_for_login IS NULL
    SQL

    change_column_default :pages, :published, false
    change_column_default :users, :otp_required_for_login, false
    change_column_null :users, :otp_required_for_login, false
  end

  def down
    change_column_null :users, :otp_required_for_login, true
    change_column_default :pages, :published, nil
    change_column_default :users, :otp_required_for_login, nil
  end
end
