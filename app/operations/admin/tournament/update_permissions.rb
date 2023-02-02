module Operations::Admin::Tournament
  class UpdatePermissions < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :tournament do
        hsh? :user_tournament_permissions_attributes, additional_properties: true
      end
    end

    model_authorization_action :update_permissions

    model ::Tournament
  end
end
