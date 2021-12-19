module Operations::Admin::User
  class UpdateProfile < RailsOps::Operation::Model::Update
    schema do
      req :id
      opt :user do
        opt :username
        opt :email
        opt :password
        opt :website
      end
    end

    model ::User
  end
end