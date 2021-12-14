module Operations::Admin::User
  class UpdatePermissions < RailsOps::Operation::Model::Update
    schema do
      req :id
      opt :user do
        opt :user_admin_permission
        opt :news_admin_permission
        opt :event_admin_permission
        opt :system_admin_permission
      end
    end

    model ::User
  end
end
