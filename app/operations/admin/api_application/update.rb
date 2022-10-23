module Operations::Admin::ApiApplication
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :api_application do
        str? :name
      end
    end

    model ::ApiApplication
  end
end
