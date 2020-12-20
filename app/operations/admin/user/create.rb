module Operations::Admin::User
  class Create < RailsOps::Operation::Model::Create
    schema do
      opt :user do
        opt :email
        opt :password
      end
    end

    model ::User
  end
end
