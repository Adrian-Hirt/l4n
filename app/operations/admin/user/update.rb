module Operations::Admin::User
  class Update < RailsOps::Operation::Model::Update
    schema do
      req :id
      opt :user do
        opt :username
        opt :email
        opt :password
        opt :website
        opt :avatar
        opt :user_admin_permission
        opt :news_admin_permission
        opt :event_admin_permission
      end
    end

    model ::User
  end
end
