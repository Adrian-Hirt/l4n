class AddAdditionalFlagsToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :location, :string
    add_column :events, :published, :boolean, null: false, default: false
  end
end
