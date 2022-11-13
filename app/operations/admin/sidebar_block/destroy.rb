module Operations::Admin::SidebarBlock
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::SidebarBlock
  end
end
