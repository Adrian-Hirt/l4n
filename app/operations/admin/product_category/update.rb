module Operations::Admin::ProductCategory
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      str! :id
      hsh? :product_category do
        str! :name
        int! :sort, cast_str: true
      end
    end

    model ::ProductCategory
  end
end
