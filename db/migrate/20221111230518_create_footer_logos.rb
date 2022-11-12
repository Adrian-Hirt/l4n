class CreateFooterLogos < ActiveRecord::Migration[7.0]
  def change
    create_table :footer_logos do |t|
      t.integer :sort, null: false, default: 0
      t.boolean :visible, null: false, default: true

      t.timestamps
    end
  end
end
