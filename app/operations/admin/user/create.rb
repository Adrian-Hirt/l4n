module Operations::Admin::User
  class Load < RailsOps::Operation::Model::Create
    schema do
      req :user do
        opt :email
        opt :password
        opt :password_confirmation
      end
      opt :commit
    end

    model ::User
  end
end
