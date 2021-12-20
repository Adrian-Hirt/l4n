module Operations::Admin::MenuItem
  class Create < RailsOps::Operation::Model::Create
    schema3 do
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
