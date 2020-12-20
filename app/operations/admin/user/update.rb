module Operations::Admin::User
  class Update < RailsOps::Operation::Model::Update
    schema do
      req :id
      opt :user do
        opt :email
        opt :password
      end
    end

    model ::User
  end
end
