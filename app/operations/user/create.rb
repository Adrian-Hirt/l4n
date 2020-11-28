module Operations::User
  class Create < RailsOps::Operation::Model::Create
    schema do
      opt :user do
        opt :email
        opt :password
        opt :password_confirmation
      end
      opt :commit
    end

    without_authorization

    model ::User
  end
end
