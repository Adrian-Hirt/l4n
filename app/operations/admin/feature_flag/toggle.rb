module Operations::Admin::FeatureFlag
  class Toggle < RailsOps::Operation::Model::Update
    schema do
      req :id
    end

    model ::FeatureFlag

    def perform
      model.toggle!(:enabled)
    end
  end
end
