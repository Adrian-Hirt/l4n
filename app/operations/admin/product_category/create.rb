module Operations::Admin::ProductCategory
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :product_category do
        str! :name
        int! :sort, cast_str: true
      end
    end

    model ::ProductCategory
  end
end
