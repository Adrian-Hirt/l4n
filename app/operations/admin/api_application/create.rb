module Operations::Admin::ApiApplication
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :api_application do
        str? :name
      end
    end

    model ::ApiApplication
  end
end
