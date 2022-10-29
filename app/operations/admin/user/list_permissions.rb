module Operations::Admin::User
  class ListPermissions < RailsOps::Operation
    policy :on_init do
      authorize! :manage, User
    end
  end
end
