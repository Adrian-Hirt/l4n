module Operations::User
  class UpdateProfile < RailsOps::Operation::Model::Update
    schema do
      opt :user do
        opt :username
        opt :email
        opt :password
        opt :password_confirmation
        opt :website
        opt :avatar
      end
    end

    # Uses context user, so no need to authorize
    without_authorization

    model ::User

    private

    def build_model
      @model = context.user
      build_nested_model_ops :update
      assign_attributes
    end
  end
end
