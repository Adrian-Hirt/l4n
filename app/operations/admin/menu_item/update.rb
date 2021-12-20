module Operations::Admin::MenuItem
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      str! :id, format: :integer
      hsh? :menu_item do
        str? :title
        str! :page_name
        str! :sort, format: :integer
        str! :visible, format: :boolean
        str? :parent_id
      end
    end

    model ::MenuItem
  end
end
