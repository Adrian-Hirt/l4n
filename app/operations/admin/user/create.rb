module Operations::Admin::User
  class Create < RailsOps::Operation::Model::Create
    schema do
      opt :user do
        opt :username
        opt :email
        opt :password
        opt :avatar
        opt :website
        opt :bio
      end
    end

    model ::User

    def perform
      model.skip_confirmation!
      super
      model.confirm
    end
  end
end
