module Operations::Admin::User
  class UpdatePermissions < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :user do
        hsh? :user_permissions_attributes, additional_properties: true
      end
    end

    model ::User

    def available_permissions
      permissions = UserPermission::AVAILABLE_PERMISSIONS.keys - model.user_permissions.select(&:persisted?).collect(&:permission)

      return permissions.map { |permission| [permission.humanize, permission] }.sort
    end

    def permission_to_modes_map
      UserPermission::AVAILABLE_PERMISSIONS.to_json
    end
  end
end
