module Operations::Admin::User
  class Create < RailsOps::Operation::Model::Create
    schema do
      opt :user do
        opt :email
        opt :password
      end
      opt :commit
    end

    model ::User
  end
end
