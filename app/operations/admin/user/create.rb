module Operations::Admin::User
  class Create < RailsOps::Operation::Model::Create
    schema do
      opt :user do
        opt :username
        opt :email
        opt :password
        opt :avatar
        opt :website
      end
    end

    model ::User
  end
end
