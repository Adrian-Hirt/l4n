class CreateUploads < ActiveRecord::Migration[7.0]
  def change
    create_table :uploads, id: :uuid do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
