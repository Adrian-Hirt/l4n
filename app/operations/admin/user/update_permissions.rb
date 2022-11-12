module Operations::Admin::User
  class UpdatePermissions < RailsOps::Operation::Model::Update
    schema do
      req :id
      opt :user do
        opt :user_admin_permission
        opt :news_admin_permission
        opt :event_admin_permission
        opt :page_admin_permission
        opt :menu_items_admin_permission
        opt :shop_admin_permission
        opt :payment_assist_admin_permission
        opt :lan_party_admin_permission
        opt :tournament_admin_permission
        opt :design_admin_permission
        opt :system_admin_permission
      end
    end

    model ::User
  end
end
