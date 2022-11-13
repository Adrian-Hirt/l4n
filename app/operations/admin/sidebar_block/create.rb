module Operations::Admin::SidebarBlock
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :sidebar_block do
        str? :visible
        str? :title
        int? :sort, cast_str: true
        str? :content
      end
    end

    model ::SidebarBlock
  end
end
