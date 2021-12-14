module Operations::Admin::User
  class RemoveAvatar < RailsOps::Operation::Model::Update
    schema do
      req :id
    end

    model ::User

    def perform
      model.avatar.purge
    end
  end
end
