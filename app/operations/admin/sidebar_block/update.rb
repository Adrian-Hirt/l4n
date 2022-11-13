module Operations::Admin::SidebarBlock
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
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
