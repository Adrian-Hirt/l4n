class ChangeTypeOfPrimaryIdOfUploadsToInt < ActiveRecord::Migration[7.0]
  def up
    # Remove primary key attribute of uploads
    execute <<~SQL.squish
      ALTER TABLE uploads DROP CONSTRAINT uploads_pkey;
    SQL

    # Rename id column
    rename_column :uploads, :id, :uuid

    # Create temp column to hold the uuid converted to an int (similar to how ruby does it)
    add_column :uploads, :int_uuid, :bigint

    # Update the temp column
    execute <<~SQL.squish
      UPDATE uploads
      SET int_uuid = (0 || substring(uuid::text FROM '\d*'))::bigint
    SQL

    # Add new ID column
    execute <<~SQL.squish
      ALTER TABLE uploads ADD COLUMN id BIGSERIAL PRIMARY KEY
    SQL

    # Update the attachments
    execute <<~SQL.squish
      UPDATE active_storage_attachments
      SET record_id = uploads.id
      FROM uploads
      WHERE record_id = uploads.int_uuid
    SQL

    # Finally, remove the temp column
    remove_column :uploads, :int_uuid
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
