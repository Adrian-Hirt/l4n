class AddStatusToPhase < ActiveRecord::Migration[7.0]
  def change
    add_column :tournament_phases, :status, :string, null: false, default: 'created'
  end
end
