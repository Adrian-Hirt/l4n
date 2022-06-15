class RemoveUsedBooleanFromPromotionCodes < ActiveRecord::Migration[7.0]
  def change
    remove_column :promotion_codes, :used, :boolean, nil: false, default: false
  end
end
