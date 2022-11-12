class AddLinkToFooterLogo < ActiveRecord::Migration[7.0]
  def change
    add_column :footer_logos, :link, :string
  end
end
