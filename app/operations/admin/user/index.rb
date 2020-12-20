module Operations::Admin::User
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, User
    end

    def users
      User.all
    end
  end
end
