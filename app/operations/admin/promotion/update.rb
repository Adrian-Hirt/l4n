module Operations::Admin::Promotion
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      str! :id
      hsh? :promotion do
        str! :name
        boo! :active, cast_str: true
        ary? :product_ids
      end
    end

    model ::Promotion
  end
end
