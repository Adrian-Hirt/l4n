module Operations::Admin::Promotion
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :promotion do
        str! :name
        boo! :active, cast_str: true
        str! :code_type
        str? :reduction
        str? :code_prefix
      end
    end

    model ::Promotion
  end
end
