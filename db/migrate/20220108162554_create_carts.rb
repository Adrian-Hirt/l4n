class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.belongs_to :user, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
