class MakeUserAssociationOnUploadsOptional < ActiveRecord::Migration[7.0]
  def change
    change_column_null :uploads, :user_id, true
  end
end
