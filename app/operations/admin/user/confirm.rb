module Operations::Admin::User
  class Confirm < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
    end

    model ::User

    def perform
      model.confirm
    end
  end
end
