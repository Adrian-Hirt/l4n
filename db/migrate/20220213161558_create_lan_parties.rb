class CreateLanParties < ActiveRecord::Migration[7.0]
  def change
    create_table :lan_parties do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
