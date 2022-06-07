module Operations::Admin::ProductCategory
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      str! :id
    end

    model ::ProductCategory
  end
end
