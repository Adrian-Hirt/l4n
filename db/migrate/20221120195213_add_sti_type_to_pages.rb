class AddStiTypeToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :type, :string, null: false, default: 'ContentPage'
    add_column :pages, :redirects_to, :string, null: true
    change_column_null :pages, :title, true
    change_column_null :pages, :published, true
  end
end
