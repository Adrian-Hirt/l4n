class AddFlagsAndOptionsToTournament < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :status, :string, null: false, default: 'draft'
    add_column :tournaments, :registration_open, :boolean, null: false, default: false
    add_column :tournaments, :max_number_of_participants, :integer, null: false, default: 0
    add_column :tournaments, :singleplayer, :boolean, null: false, default: false
  end
end
