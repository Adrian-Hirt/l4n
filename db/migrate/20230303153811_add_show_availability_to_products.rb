class AddShowAvailabilityToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :show_availability, :boolean, default: false, null: false
  end
end
