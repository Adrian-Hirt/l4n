class RemoveUserAssociationFromNewsPost < ActiveRecord::Migration[7.0]
  def change
    remove_belongs_to :news_posts, :user, null: false, foreign_key: true
  end
end
