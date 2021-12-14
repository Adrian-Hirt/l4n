module Operations::Admin::User
  class UpdateAvatar < RailsOps::Operation::Model::Update
    schema do
      req :id
      opt :croppedImage
    end

    model ::User

    def perform
      model.avatar.attach(params[:croppedImage])
    end
  end
end
